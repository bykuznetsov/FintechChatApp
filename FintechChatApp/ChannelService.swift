//
//  ChannelService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol ChannelServiceProtocol {
    func fetchAndCacheChannels()
    func addNewChannel(channel: Channel)
    func deleteChannel(at documentPath: String)
}

///Service for getting channels from Firestore server and caching it to CoreData
///Using (Core Components):
///-Firestore: ChannelPath
///-CoreData: SaveRequest,  ChannelRequest

class ChannelService: ChannelServiceProtocol {
    
    let saveRequest: SaveRequestProtocol
    let channelRequest: ChannelRequestProtocol
    let channelPath: ChannelPathProtocol
    let fsChannelRequest: FSChannelRequestProtocol
    
    var channels: [Channel]  = []
    
    init(saveRequest: SaveRequestProtocol, channelRequest: ChannelRequestProtocol, channelPath: ChannelPathProtocol, fsChannelRequest: FSChannelRequestProtocol) {
        self.saveRequest = saveRequest
        self.channelRequest = channelRequest
        self.channelPath = channelPath
        self.fsChannelRequest = fsChannelRequest
    }
    
    func addNewChannel(channel: Channel) {
        fsChannelRequest.addNewChannel(channel: channel)
    }
    
    func deleteChannel(at documentPath: String) {
        fsChannelRequest.deleteChannel(at: documentPath)
    }
    
    func fetchAndCacheChannels() {
        
        channelPath.reference.addSnapshotListener { [weak self] (snapshot, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self?.channels = documents.compactMap { queryDocumentSnapshot -> Channel? in
                
                let identifier = queryDocumentSnapshot.documentID
                
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let lastMessage = data["lastMessage"] as? String ?? ""
                let lastActivity = data["lastActivity"] as? Date
                
                //Remove invalid data
                if name.isEmpty {
                    return nil
                }
                
                return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
            }
            
            self?.saveRequest.performSave { context in
                
                //Deleting from CoreData.
                let dbChannels = self?.channelRequest.fetchAllChannels(in: context)
                
                //Get arrays of Identifiers.
                let dbIdentifiers = dbChannels?.map { $0.identifier }
                let identifiers = self?.channels.map { $0.identifier }
                
                //Check if data from server doesn't include id's from CoreData -> Delete.
                if let dbIdentifiers = dbIdentifiers, let identifiers = identifiers {
                    for dbIdentifier in dbIdentifiers {
                        if let dbIdentifier = dbIdentifier {
                            if !identifiers.contains(dbIdentifier) {
                                self?.channelRequest.deleteChannelById(by: dbIdentifier, in: context)
                            }
                        }
                    }
                }
                    
                //Updating and inserting in CoreData.
                if let channels = self?.channels {
                    for channel in channels {
                        
                        let identifier = channel.identifier
                        let name = channel.name
                        let lastMessage = channel.lastMessage
                        let lastActivity = channel.lastActivity
                        
                        let dbChannel = self?.channelRequest.fetchChannelById(by: identifier, in: context)
                        
                        //If channel exist in CoreData -> update it.
                        if let dbChannel = dbChannel {
                            dbChannel.name = name
                            dbChannel.lastMessage = lastMessage
                            dbChannel.lastActivity = lastActivity
                        } else { //If channel not exist in CoreData -> insert it.
                            
                            _ = DBChannel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity, in: context)
                        }
                        
                    }
                }
                
            }
        }
    }
    
}
