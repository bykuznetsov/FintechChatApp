//
//  MessageFRC.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol IMessageFRC {
    func messagesFetchedResultsController(channelId id: String) -> NSFetchedResultsController<DBMessage>
}

class MessageFRC: IMessageFRC {
    
    //NSFetchedResultsController for ConversationViewController tableView
    func messagesFetchedResultsController(channelId id: String) -> NSFetchedResultsController<DBMessage> {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", id)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.fetchBatchSize = 20

        // Initialize Fetched Results Controller
        let mainContext = CoreDataStack.shared.mainContext
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }
    
}
