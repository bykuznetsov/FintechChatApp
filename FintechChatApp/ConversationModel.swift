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
    func fetchAndCacheMessages()
    func getFRC() -> NSFetchedResultsController<DBMessage>
    func addNewMessage(message: Message)
    func deleteChannel(at documentPath: String)
    func gcdGetProfileName() -> String?
    func getTheme() -> Theme
}

class ConversationModel: IConversationModel {
    
    var delegate: IConversationModelDelegate?
    
    var messageService: IMessageService
    let messageFRC: IMessageFRC
    let themeService: IThemeService
    let profileService: IProfileService
    
    var documentId: String
    
    init(messageService: IMessageService, messageFRC: IMessageFRC, themeService: IThemeService, profileService: IProfileService, documentId: String) {
        self.messageService = messageService
        self.messageFRC = messageFRC
        self.themeService = themeService
        self.profileService = profileService
        self.documentId = documentId
    }
    
    func addNewMessage(message: Message) {
        self.messageService.addNewMessage(message: message)
    }
    
    func deleteChannel(at documentPath: String) {
        self.messageService.deleteMessage(at: documentPath)
    }
    
    func fetchAndCacheMessages() {
        self.messageService.fetchAndCacheMessages(documentId: self.documentId)
    }
    
    func getFRC() -> NSFetchedResultsController<DBMessage> {
        self.messageFRC.messagesFetchedResultsController(channelId: self.documentId)
    }
    
    func gcdGetProfileName() -> String? {
        return self.profileService.getProfileName()
    }
    
    func getTheme() -> Theme {
        return self.themeService.getTheme()
    }
    
}
