//
//  CoreAssembly.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 09.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    
    //CoreData
    var coreDataStack: CoreDataStackProtocol { get }
    
    var saveRequest: SaveRequestProtocol { get }
    var channelRequest: ChannelRequestProtocol { get }
    var messageRequest: MessageRequestProtocol { get }
    
    //Firestore
    var channelPath: ChannelPathProtocol { get }
    var messagePath: MessagePathProtocol { get }
    
    var fsChannelRequest: FSChannelRequestProtocol { get }
    var fsMessageRequest: FSMessageRequestProtocol { get }
    
    //UserDefaults
    var userDefaultsEntity: UserDefaultsEntityProtocol { get }
    
    //File Manager
    var fmProfileRequest: FMProfileRequestProtocol { get }
    
    var fmGCDProfileRequest: FMProfileRequestProtocol { get }
    var fmOperationProfileRequest: FMProfileRequestProtocol { get }
    
}

class CoreAssembly: CoreAssemblyProtocol {
    
    //CoreData
    lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack.shared

    lazy var saveRequest: SaveRequestProtocol = SaveRequest(coreDataStack: self.coreDataStack)
    
    lazy var channelRequest: ChannelRequestProtocol = ChannelRequest()
    lazy var messageRequest: MessageRequestProtocol = MessageRequest()
    
    //Firestore
    lazy var channelPath: ChannelPathProtocol = ChannelPath()
    lazy var messagePath: MessagePathProtocol = MessagePath(documentId: "")
    
    lazy var fsChannelRequest: FSChannelRequestProtocol = FSChannelRequest(channelPath: self.channelPath)
    lazy var fsMessageRequest: FSMessageRequestProtocol = FSMessageRequest(messagePath: self.messagePath)
    
    //UserDefaults
    lazy var userDefaultsEntity: UserDefaultsEntityProtocol = UserDefaultsEntity()
    
    //File Manager
    internal lazy var fmProfileRequest: FMProfileRequestProtocol = FMProfileRequest()
    
    lazy var fmGCDProfileRequest: FMProfileRequestProtocol = FMGCDProfileRequest(fmProfileRequest: self.fmProfileRequest)
    lazy var fmOperationProfileRequest: FMProfileRequestProtocol = FMOperationProfileRequest(fmProfileRequest: self.fmProfileRequest)
    
}
