//
//  MessageFetchService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol IMessageRequest {
    func fetchMessageById(by id: String, in context: NSManagedObjectContext) -> DBMessage?
}

class MessageRequest: IMessageRequest {
    
    func fetchMessageById(by id: String, in context: NSManagedObjectContext) -> DBMessage? {
        
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
        
        do {
            let messages = try context.fetch(fetchRequest)
            
            if let message = messages.first {
                return message
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
}
