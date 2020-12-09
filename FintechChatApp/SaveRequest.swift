//
//  saveService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 10.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol ISaveRequest {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
}

class SaveRequest: ISaveRequest {
    
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.coreDataStack.saveContext()
        context.perform { [weak self] in
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                } catch {
                    print(assertionFailure(error.localizedDescription))
                }
                
                self?.performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
                if let parent = context.parent { self.performSave(in: parent) }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        
    }
    
}
