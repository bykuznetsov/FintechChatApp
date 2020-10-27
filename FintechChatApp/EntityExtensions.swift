//
//  Entiti.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 24.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

extension DBChannel {
    convenience init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, in context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        
    }
    
    var about: String {
        
        var description = ""
        
        if let name = self.name, let messages = self.messages, let countOfMessages = self.messages?.count {
            description = "👥 \(String(describing: name)) (Количество сообщений: \(String(describing: countOfMessages)))"
            
            for message in messages {
                if let message = message as? DBMessage {
                    description.append("\n   ✉️ \(message.about)")
                }
            }

        }
        
        return description
    }
    
}

extension DBMessage {
    convenience init(identifier: String, content: String, created: Date, senderId: String, senderName: String, in context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
        
    }
    
    var about: String {
        
        var description = ""
        
        if let senderName = senderName, let content = content {
            description = "\(String(describing: senderName)) : \(String(describing: content))"
        }
        
        return description
    }
}
