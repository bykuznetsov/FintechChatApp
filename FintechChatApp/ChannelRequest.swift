//
//  FetchService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelRequestProtocol {
    func fetchAllChannels(in context: NSManagedObjectContext) -> [DBChannel]?
    func fetchChannelById(by id: String, in context: NSManagedObjectContext) -> DBChannel?
    func deleteChannelById(by id: String, in context: NSManagedObjectContext)
}

class ChannelRequest: ChannelRequestProtocol {
    
    func fetchAllChannels(in context: NSManagedObjectContext) -> [DBChannel]? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        
        do {
            let channels = try context.fetch(fetchRequest)
            return channels
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchChannelById(by id: String, in context: NSManagedObjectContext) -> DBChannel? {
        
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
        
        do {
            let channels = try context.fetch(fetchRequest)
            
            if let channel = channels.first {
                return channel
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
    func deleteChannelById(by id: String, in context: NSManagedObjectContext) {
    
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
        
        context.perform {
            do {
                
                let channels = try context.fetch(fetchRequest)
                guard let channel = channels.first else { return }
                
                context.delete(channel)
        
            } catch {
                print(error)
            }
        }
        
    }
    
}
