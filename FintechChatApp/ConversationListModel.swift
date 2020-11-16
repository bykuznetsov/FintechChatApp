//
//  ConversationListModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

struct CellDisplayModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

protocol IConversationListModelDelegate: class {
    //func setup(dataSource: [CellDisplayModel])
}

protocol IConversationListModel: class {
    var delegate: IConversationListModelDelegate? { get set }
    func fetchAndCacheChannels()
    func getFRC() -> NSFetchedResultsController<DBChannel>
    func addNewChannel(channel: Channel)
    func deleteChannel(at documentPath: String)
    func getTheme() -> Theme
}

class ConversationListModel: IConversationListModel {

    weak var delegate: IConversationListModelDelegate?
    
    let channelService: ChannelServiceProtocol
    let channelFRC: ChannelFRCProtocol
    let themeService: ThemeServiceProtocol
    
    init(channelService: ChannelServiceProtocol, channelFRC: ChannelFRCProtocol, themeService: ThemeServiceProtocol) {
        self.channelService = channelService
        self.channelFRC = channelFRC
        self.themeService = themeService
    }
    
    func fetchAndCacheChannels() {
        channelService.fetchAndCacheChannels()
    }
    
    func getFRC() -> NSFetchedResultsController<DBChannel> {
        channelFRC.channelsFetchedResultsController()
    }
    
    func addNewChannel(channel: Channel) {
        channelService.addNewChannel(channel: channel)
    }
    
    func deleteChannel(at documentPath: String) {
        channelService.deleteChannel(at: documentPath)
    }
    
    func getTheme() -> Theme {
        return self.themeService.getTheme()
    }
    
}
