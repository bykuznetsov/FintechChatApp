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
    
    //Get exist channels from Firebase, remove invalid data, sort by date of lastActivity.
    func fetchingChannels() {
        
        reference.addSnapshotListener { [weak self] snapshot, _ in
            
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
            
            //Caching data
            self?.coreDataStack.performSave { context in
                
                if let channels = self?.channels {
                    for channel in channels {
                        
                        let identifier = channel.identifier
                        let name = channel.name
                        let lastMessage = channel.lastMessage
                        let lastActivity = channel.lastActivity
                        
                        _ = DBChannel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity, in: context)
                        
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
        //Delete from cache
        self.coreDataStack.deleteChannelById(by: documentPath)
        //Delete from server
        reference.document("\(documentPath)").delete()
        
    }
    
}
