//
//  FSChannelRequest.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

protocol IFSChannelRequest {
    func addNewChannel(channel: Channel)
    func deleteChannel(at documentPath: String)
}

///Request's with channels in Firestore (add, delete...)
class FSChannelRequest: IFSChannelRequest {
    
    var channelPath: IChannelPath
    
    init(channelPath: IChannelPath) {
        self.channelPath = channelPath
    }
    
    func addNewChannel(channel: Channel) {
        channelPath.reference.addDocument(data: [
            "name": channel.name as String? as Any,
            "lastMessage": channel.lastMessage as String? as Any,
            "lastActivity": channel.lastActivity as Date? as Any
        ])
    }
    
    func deleteChannel(at documentPath: String) {
        channelPath.reference.document("\(documentPath)").delete()
    }
    
}
