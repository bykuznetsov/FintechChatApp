//
//  MessageServiceMocks.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 02.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import Foundation
import CoreData
import Firebase

class MessageRequestMock: IMessageRequest {
    
    var fetchingMessageByIdCount: Int = 0
    
    func fetchMessageById(by id: String, in context: NSManagedObjectContext) -> DBMessage? {
        fetchingMessageByIdCount += 1
        return nil
    }
}

class MessagePathMock: IMessagePath {
    
    var gettingReferenceCount: Int = 0
    
    var db: Firestore {
        return Firestore.firestore()
    }
    
    var reference: CollectionReference {
        gettingReferenceCount += 1
        return db.collection("channels")
    }
    
    var documentId: String = ""
    
}

class FSMessageRequestMock: IFSMessageRequest {
    
    var addingNewMessageCount: Int = 0
    var deletingMessageCount: Int = 0
    
    var addedMessage: Message?
    var deletedMessageDocumentPath: String?
    
    func addNewMessage(message: Message) {
        addingNewMessageCount += 1
        addedMessage = message
    }
    
    func deleteMessage(at documentPath: String) {
        deletingMessageCount += 1
        deletedMessageDocumentPath = documentPath
    }
    
}
