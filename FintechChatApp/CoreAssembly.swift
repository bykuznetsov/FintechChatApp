//
//  CoreAssembly.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 09.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    
    //CoreData
    var coreDataStack: ICoreDataStack { get }
    
    var saveRequest: ISaveRequest { get }
    var channelRequest: IChannelRequest { get }
    var messageRequest: IMessageRequest { get }
    
    //Firestore
    var channelPath: IChannelPath { get }
    var messagePath: IMessagePath { get }
    
    var fsChannelRequest: IFSChannelRequest { get }
    var fsMessageRequest: IFSMessageRequest { get }
    
    //UserDefaults
    var userDefaultsEntity: IUserDefaultsEntity { get }
    
    //File Manager
    var fmProfileRequest: IFMProfileRequest { get }
    
    var fmGCDProfileRequest: IFMProfileRequest { get }
    var fmOperationProfileRequest: IFMProfileRequest { get }
    
    //Networking
    var networkRequestSender: IRequestSender { get }
    
}

class CoreAssembly: ICoreAssembly {
    
    //CoreData
    lazy var coreDataStack: ICoreDataStack = CoreDataStack.shared

    lazy var saveRequest: ISaveRequest = SaveRequest(coreDataStack: self.coreDataStack)
    
    lazy var channelRequest: IChannelRequest = ChannelRequest()
    lazy var messageRequest: IMessageRequest = MessageRequest()
    
    //Firestore
    lazy var channelPath: IChannelPath = ChannelPath()
    lazy var messagePath: IMessagePath = MessagePath(documentId: "")
    
    lazy var fsChannelRequest: IFSChannelRequest = FSChannelRequest(channelPath: self.channelPath)
    lazy var fsMessageRequest: IFSMessageRequest = FSMessageRequest(messagePath: self.messagePath)
    
    //UserDefaults
    lazy var userDefaultsEntity: IUserDefaultsEntity = UserDefaultsEntity()
    
    //File Manager
    internal lazy var fmProfileRequest: IFMProfileRequest = FMProfileRequest()
    
    lazy var fmGCDProfileRequest: IFMProfileRequest = FMGCDProfileRequest(fmProfileRequest: self.fmProfileRequest)
    lazy var fmOperationProfileRequest: IFMProfileRequest = FMOperationProfileRequest(fmProfileRequest: self.fmProfileRequest)
    
    //Networking
    lazy var networkRequestSender: IRequestSender = RequestSender()
    
}
