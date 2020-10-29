//
//  ConversationData.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 08.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ConversationServerManager {
    
    lazy var db = Firestore.firestore()
    lazy var documentId = ""
    lazy var reference = db.collection("channels").document("\(documentId)").collection("messages")
    
    var messages: [Message] = []
    
    //Object for caching data from Firebase server
    lazy var coreDataStack = CoreDataStack.shared
    
    //Channel from CoreData
    var channelCoreData: DBChannel?
    
    init(documentId: String) {
        self.documentId = documentId
    }
    
    //Data Model
    struct Message {
        let identifier: String
        let content: String
        let created: Date
        let senderId: String
        let senderName: String
    }
    
    //Get exist messages from Firebase, remove invalid data, sort by date of lastActivity.
    func fetchingMessages(for tableView: UITableView) {
        
        reference.addSnapshotListener { [weak self] snapshot, _ in
            
            guard let documents = snapshot?.documents else { return }
            
            self?.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                
                let identifier = queryDocumentSnapshot.documentID
                
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String ?? ""
                let created = data["created"] as? Timestamp ?? Timestamp()
                let senderId = data["senderId"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                
                //Remove invalid data
                if content.isEmpty || senderId.isEmpty || senderName.isEmpty {
                    return nil
                }
                
                return Message(identifier: identifier, content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
            }
            
            //Sort Messages by date
            self?.messages.sort { $0.created.compare($1.created) == .orderedAscending }
            
            //Flip data (because our tableView reversed)
            self?.messages.reverse()
            
            //Caching data
            self?.coreDataStack.performSave { context in
                
                //Find channel
                DispatchQueue.main.async {
                    if let id = self?.documentId {
                        if let channel = self?.coreDataStack.fetchChannelById(by: id, in: context) {
                            self?.channelCoreData = channel
                        }
                    }
                }
                
                if let messages = self?.messages {
                    for message in messages {
                        
                        let identifier = message.identifier
                        let content = message.content
                        let created = message.created
                        let senderId = message.senderId
                        let senderName = message.senderName
                        
                        let message = DBMessage( identifier: identifier, content: content, created: created, senderId: senderId, senderName: senderName, in: context)
                        
                        //Add messages to the channel
                        if let channelCoreData = self?.channelCoreData {
                            channelCoreData.addToMessages(message)
                        }
                        
                    }
                }
            }
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
        
    }
    
    func addNewMessage(message: Message) {
        reference.addDocument(data: [
            "content": message.content,
            "created": Timestamp(),
            "senderId": message.senderId,
            "senderName": message.senderName
        ])
    }
    
}
