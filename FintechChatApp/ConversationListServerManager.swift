//
//  ConversationListData.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 08.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ConversationListServerManager {
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var channels: [Channel]  = []
    
    //Data Model
    struct Channel {
        let identifier: String
        let name: String
        let lastMessage: String?
        let lastActivity: Date?
    }
     
    //Object for caching data from Firebase server
    lazy var coreDataStack = CoreDataStack.shared
    
    //Get exist channels from Firebase, remove invalid data and caching it.
    func fetchingChannels() {
        
        reference.addSnapshotListener { [weak self] (snapshot, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self?.channels = documents.compactMap { queryDocumentSnapshot -> Channel? in
                
                let identifier = queryDocumentSnapshot.documentID
                
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let lastMessage = data["lastMessage"] as? String ?? ""
                let lastActivity = data["lastActivity"] as? Timestamp
                
                //Remove invalid data
                if name.isEmpty {
                    return nil
                }
                
                if (lastMessage.isEmpty && lastActivity != nil) || (!lastMessage.isEmpty && lastActivity == nil) {
                    return nil
                }
                
                return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity?.dateValue())
            }
            
            //Caching data.
            self?.coreDataStack.performSave { context in
                    
                //Updating and inserting in CoreData.
                if let channels = self?.channels {
                    for channel in channels {
                        
                        let identifier = channel.identifier
                        let name = channel.name
                        let lastMessage = channel.lastMessage
                        let lastActivity = channel.lastActivity
                        
                        let dbChannel = self?.coreDataStack.fetchChannelById(by: identifier, in: context)
                        
                        //If channel exist in CoreData -> update it.
                        if let dbChannel = dbChannel {
                            dbChannel.name = name
                            dbChannel.lastMessage = lastMessage
                            dbChannel.lastActivity = lastActivity
                        } else { //If channel not exist in CoreData -> insert it.
                            
                            _ = DBChannel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity, in: context)
                        }
                        
                    }
                }
                
                //Deleting from CoreData.
                let dbChannels = self?.coreDataStack.fetchAllChannels(in: context)
                
                //Get arrays of Identifiers.
                let dbIdentifiers = dbChannels?.map { $0.identifier }
                let identifiers = self?.channels.map { $0.identifier }
                
                //Check if data from server doesn't include id's from CoreData -> Delete.
                if let dbIdentifiers = dbIdentifiers, let identifiers = identifiers {
                    for dbIdentifier in dbIdentifiers {
                        if let dbIdentifier = dbIdentifier {
                            if !identifiers.contains(dbIdentifier) {
                                self?.coreDataStack.deleteChannelById(by: dbIdentifier, in: context)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func addNewChannel(channel: Channel) {
        reference.addDocument(data: [
            "name": channel.name,
            "lastMessage": channel.lastMessage as String? as Any,
            "lastActivity": channel.lastActivity as Date? as Any
        ])
    }
    
    func deleteChannel(at documentPath: String) {
        //Delete from server
        reference.document("\(documentPath)").delete()
    }
    
}
