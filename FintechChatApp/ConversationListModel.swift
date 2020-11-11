//
//  ConversationListModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

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
}

class ConversationListModel: IConversationListModel {
    
    weak var delegate: IConversationListModelDelegate?
    
    let channelService: ChannelServiceProtocol
    let channelFRC: ChannelFRCProtocol
    
    init(channelService: ChannelServiceProtocol, channelFRC: ChannelFRCProtocol) {
        self.channelService = channelService
        self.channelFRC = channelFRC
    }
    
    func fetchAndCacheChannels() {
        channelService.fetchAndCacheChannels()
    }
    
}
