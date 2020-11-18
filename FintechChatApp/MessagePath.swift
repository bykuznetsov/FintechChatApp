//
//  MessagePath.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase

protocol IMessagePath {
    var db: Firestore { get }
    var reference: CollectionReference { get }
    
    var documentId: String { get set }
}

///Make something with collection of messages in Firestore server (for example: fetching messages from server)
class MessagePath: IMessagePath {
    
    var documentId: String
    lazy var db: Firestore = Firestore.firestore()
    lazy var reference: CollectionReference = db.collection("channels").document("\(documentId)").collection("messages")
    
    init(documentId: String) {
        self.documentId = documentId
    }
    
}
