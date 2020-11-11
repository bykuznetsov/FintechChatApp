//
//  ChannelsFRC.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelFRCProtocol {
    func channelsFetchedResultsController() -> NSFetchedResultsController<DBChannel>
}

class ChannelFRC: ChannelFRCProtocol {
    
    //NSFetchedResultsController for ConversationListViewController tableView
    func channelsFetchedResultsController() -> NSFetchedResultsController<DBChannel> {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptorByLastActivity = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortDescriptorByLastMessage = NSSortDescriptor(key: "lastMessage", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptorByLastActivity, sortDescriptorByLastMessage]
        
        fetchRequest.fetchBatchSize = 20

        // Initialize Fetched Results Controller
        let mainContext = CoreDataStack.shared.mainContext
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
}
