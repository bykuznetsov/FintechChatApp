//
//  ServiceAssembly.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 09.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var channelFRC: IChannelFRC { get }
    var messageFRC: IMessageFRC { get }
    
    var channelService: IChannelService { get }
    var messageService: IMessageService { get }
    
    var themeService: IThemeService { get }
    
    var gcdProfileService: IProfileService { get }
    var operationProfileService: IProfileService { get }
}

class ServiceAssembly: IServiceAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelFRC: IChannelFRC = ChannelFRC()
    lazy var messageFRC: IMessageFRC = MessageFRC()
    
    lazy var channelService: IChannelService = ChannelService(saveRequest: self.coreAssembly.saveRequest,
                                                                     channelRequest: self.coreAssembly.channelRequest,
                                                                     channelPath: self.coreAssembly.channelPath,
                                                                     fsChannelRequest: self.coreAssembly.fsChannelRequest)
    
    lazy var messageService: IMessageService = MessageService(saveRequest: self.coreAssembly.saveRequest,
                                                                     messageRequest: self.coreAssembly.messageRequest,
                                                                     messagePath: self.coreAssembly.messagePath,
                                                                     channelRequest: self.coreAssembly.channelRequest,
                                                                     fsMessageRequest: self.coreAssembly.fsMessageRequest,
                                                                     documentId: "")
    
    lazy var themeService: IThemeService = ThemeService(userDefaultsEntity: self.coreAssembly.userDefaultsEntity)
    
    lazy var gcdProfileService: IProfileService = GCDProfileService(fmGCDProfileRequest: self.coreAssembly.fmGCDProfileRequest)
    lazy var operationProfileService: IProfileService = OperationProfileService(fmOperationProfileRequest: self.coreAssembly.fmOperationProfileRequest)
}
