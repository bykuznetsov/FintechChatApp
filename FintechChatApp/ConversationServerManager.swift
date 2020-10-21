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
    
    init(documentId: String) {
        self.documentId = documentId
    }
    
    //Data Model
    struct Message {
        let content: String
        let created: Date
        let senderId: String
        let senderName: String
    }
    
    //Get exist messages from Firebase, remove invalid data, sort by date of lastActivity.
    func fetchingMessages(for tableView: UITableView) {
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            
            guard let documents = snapshot?.documents else { return }
            
            self?.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String ?? ""
                let created = data["created"] as? Timestamp ?? Timestamp()
                let senderId = data["senderId"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                
                //Remove invalid data
                if content.isEmpty || senderId.isEmpty || senderName.isEmpty {
                    return nil
                }
                
                return Message(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
            }
            
            //Sort Messages by date
            self?.messages.sort { $0.created.compare($1.created) == .orderedAscending }
            
            DispatchQueue.main.async {
                tableView.reloadData()
                
                //Scroll TableView to the bottom
                guard let countOfMessages = self?.messages.count else { return }
                if countOfMessages > 0 {
                    let indexPath = IndexPath(row: countOfMessages-1, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            }
            
        }
        
    }
    
    func addNewMessage(message: Message) {
        reference.addDocument(data: [
            "content" :message.content,
            "created" : message.created,
            "senderId" : message.senderId,
            "senderName" : message.senderName
        ])
    }
    
}
