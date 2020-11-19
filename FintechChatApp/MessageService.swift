//
//  MessageService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IMessageService {
    func fetchAndCacheMessages(documentId: String)
    func addNewMessage(message: Message)
    func deleteMessage(at documentPath: String)
    var documentId: String? { get set }
}

///Service for getting messages from Firestore server and caching it to CoreData (maps to channel)
///Using (Core Components):
///-Firestore: MessagePath
///-CoreData: SaveRequest, MessageRequest, ChannelRequest

class MessageService: IMessageService {
    
    let saveRequest: ISaveRequest
    let messageRequest: IMessageRequest
    var messagePath: IMessagePath
    let fsMessageRequest: IFSMessageRequest
    let channelRequest: IChannelRequest
    
    var messages: [Message] = []
    
    var documentId: String?
    var channelCoreData: DBChannel?
    
    init(saveRequest: ISaveRequest,
         messageRequest: IMessageRequest,
         messagePath: IMessagePath,
         channelRequest: IChannelRequest,
         fsMessageRequest: IFSMessageRequest,
         documentId: String) {
        
        self.saveRequest = saveRequest
        self.messageRequest = messageRequest
        
        self.messagePath = messagePath
        self.fsMessageRequest = fsMessageRequest
        self.messagePath.documentId = documentId
        
        self.channelRequest = channelRequest
    }
    
    func addNewMessage(message: Message) {
        self.fsMessageRequest.addNewMessage(message: message)
    }
    
    func deleteMessage(at documentPath: String) {
        self.fsMessageRequest.deleteMessage(at: documentPath)
    }
    
    func fetchAndCacheMessages(documentId: String) {
        
        messagePath.reference.addSnapshotListener { [weak self] (snapshot, _) in
            
            guard let documents = snapshot?.documents else { return }
            
            self?.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                
                let identifier = queryDocumentSnapshot.documentID
                
                let data = queryDocumentSnapshot.data()
                
                let content = data["content"] as? String ?? ""
                let created = data["created"] as? Date ?? Date()
                let senderId = data["senderId"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                
                //Remove invalid data
                if content.isEmpty || senderId.isEmpty || senderName.isEmpty {
                    return nil
                }
                
                return Message(identifier: identifier, content: content, created: created, senderId: senderId, senderName: senderName)
            }
            
            //Caching data
            self?.saveRequest.performSave { context in
                
                //Find channel
                //if let id = self?.documentId {
                if let channel = self?.channelRequest.fetchChannelById(by: documentId, in: context) {
                        self?.channelCoreData = channel
                    }
                //}
                
                if let messages = self?.messages {
                    for message in messages {
                        
                        let identifier = message.identifier
                        let content = message.content
                        let created = message.created
                        let senderId = message.senderId
                        let senderName = message.senderName
                        
                        let dbMessage = self?.messageRequest.fetchMessageById(by: identifier, in: context)
                        
                        //If message exist in CoreData -> update it
                        if let dbMessage = dbMessage {
                            dbMessage.content = content
                            dbMessage.created = created
                            dbMessage.senderId = senderId
                            dbMessage.senderName = senderName
                        } else { //If message not exist in CoreData -> insert it
                            
                            let message = DBMessage( identifier: identifier, content: content, created: created, senderId: senderId, senderName: senderName, in: context)
                            
                            //Add messages to the channel
                            if let channelCoreData = self?.channelCoreData {
                                channelCoreData.addToMessages(message)
                            }
                        }
                        
                    }
                }
            }
            
        }
        
    }

}
