//
//  FSMessageRequest.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase

struct Message: Equatable {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

protocol IFSMessageRequest {
    func addNewMessage(message: Message)
    func deleteMessage(at documentPath: String)
}

///Request's with messages in Firestore (add, delete...)
class FSMessageRequest: IFSMessageRequest {
    
    var messagePath: IMessagePath
    
    init(messagePath: IMessagePath) {
        self.messagePath = messagePath
    }
    
    func addNewMessage(message: Message) {
        messagePath.reference.addDocument(data: [
            "content": message.content as String? as Any,
            "created": Timestamp(),
            "senderId": message.senderId as String? as Any,
            "senderName": message.senderName as String? as Any
        ])
    }
    
    func deleteMessage(at documentPath: String) {
        messagePath.reference.document("\(documentPath)").delete()
    }
    
}
