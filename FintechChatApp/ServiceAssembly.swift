//
//  ServiceAssembly.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 09.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
    var channelFRC: ChannelFRCProtocol { get }
    var messageFRC: MessageFRCProtocol { get }
    
    var channelService: ChannelServiceProtocol { get }
    var messageService: MessageServiceProtocol { get }
    
    var themeService: ThemeServiceProtocol { get }
    
    var gcdProfileService: ProfileServiceProtocol { get }
    var operationProfileService: ProfileServiceProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelFRC: ChannelFRCProtocol = ChannelFRC()
    lazy var messageFRC: MessageFRCProtocol = MessageFRC()
    
    lazy var channelService: ChannelServiceProtocol = ChannelService(saveRequest: self.coreAssembly.saveRequest,
                                                                     channelRequest: self.coreAssembly.channelRequest,
                                                                     channelPath: self.coreAssembly.channelPath,
                                                                     fsChannelRequest: self.coreAssembly.fsChannelRequest)
    
    lazy var messageService: MessageServiceProtocol = MessageService(saveRequest: self.coreAssembly.saveRequest,
                                                                     messageRequest: self.coreAssembly.messageRequest,
                                                                     messagePath: self.coreAssembly.messagePath,
                                                                     channelRequest: self.coreAssembly.channelRequest,
                                                                     fsMessageRequest: self.coreAssembly.fsMessageRequest,
                                                                     documentId: "")
    
    lazy var themeService: ThemeServiceProtocol = ThemeService(userDefaultsEntity: self.coreAssembly.userDefaultsEntity)
    
    lazy var gcdProfileService: ProfileServiceProtocol = GCDProfileService(fmGCDProfileRequest: self.coreAssembly.fmGCDProfileRequest)
    lazy var operationProfileService: ProfileServiceProtocol = OperationProfileService(fmOperationProfileRequest: self.coreAssembly.fmOperationProfileRequest)
}
