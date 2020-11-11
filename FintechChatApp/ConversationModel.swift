//
//  ConversationModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationModelDelegate: class {
    //func setup(dataSource: [CellDisplayModel])
}

protocol IConversationModel: class {
    var delegate: IConversationModelDelegate? { get set }
    func fetchAndCacheMessages(from documentId: String)
}

class ConversationModel: IConversationModel {
    
    var delegate: IConversationModelDelegate?
    
    var messageService: MessageServiceProtocol
    let messageFRC: MessageFRCProtocol
    
    init(messageService: MessageServiceProtocol, messageFRC: MessageFRCProtocol) {
        self.messageService = messageService
        self.messageFRC = messageFRC
    }
    
    func fetchAndCacheMessages(from documentId: String) {
        self.messageService.documentId = documentId
        self.messageService.fetchAndCacheMessages()
    }
    
    func getFRC(channelId id: String) -> NSFetchedResultsController<DBMessage> {
        self.messageFRC.messagesFetchedResultsController(channelId: id)
    }
    
}
