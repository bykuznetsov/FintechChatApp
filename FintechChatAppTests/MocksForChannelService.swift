//
//  ChannelServiceMocks.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 02.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import Foundation
import CoreData
import Firebase

class SaveRequestMock: ISaveRequest {
    
    var savingCount: Int = 0

    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        savingCount += 1
    }
    
}

class ChannelRequestMock: IChannelRequest {
    
    var fetchingAllChannelsCount: Int = 0
    var fetchingChannelByIdCount: Int = 0
    var deletingChannelByIdCount: Int = 0
    
    func fetchAllChannels(in context: NSManagedObjectContext) -> [DBChannel]? {
        fetchingAllChannelsCount += 1
        return nil
    }
    
    func fetchChannelById(by id: String, in context: NSManagedObjectContext) -> DBChannel? {
        fetchingChannelByIdCount += 1
        return nil
    }
    
    func deleteChannelById(by id: String, in context: NSManagedObjectContext) {
        deletingChannelByIdCount += 1
    }
    
}

class ChannelPathMock: IChannelPath {

    var gettingReferenceCount: Int = 0
    
    internal var db: Firestore {
        return Firestore.firestore()
    }
    
    var reference: CollectionReference {
        gettingReferenceCount += 1
        return db.collection("channels")
    }
}

class FSChannelRequestMock: IFSChannelRequest {
    
    var addingNewChannelCount: Int = 0
    var deletingChannelCount: Int = 0
    
    var addedChannel: Channel?
    var deletedChannelDocumentPath: String?
    
    func addNewChannel(channel: Channel) {
        addingNewChannelCount += 1
        addedChannel = channel
    }
    
    func deleteChannel(at documentPath: String) {
        deletingChannelCount += 1
        deletedChannelDocumentPath = documentPath
    }
}
