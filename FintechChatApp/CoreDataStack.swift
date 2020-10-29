//
//  CoreDataStack.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 23.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

//Singleton, first init and setup in AppDelegate.swift.
class CoreDataStack {
    
    private init() {}
    
    static var shared: CoreDataStack = {
        
        return CoreDataStack()
    }()
    
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Document path not found")
        }
        
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("Model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let globalBackgroundQueue = DispatchQueue.global(qos: .background)
        
        globalBackgroundQueue.async {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
    
    // MARK: - CoreData Observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        
        let name = NSNotification.Name.NSManagedObjectContextObjectsDidChange
        
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: name, object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        //For console
        print("", terminator: Array(repeating: "\n", count: 20).joined())
        
        print("🆕➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🆕")
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            
            print("Добавлено объектов: \(inserts.count)")
            print("Из них:")
            
            if let insertChannels = inserts as? Set<DBChannel> {
                print("🟢 \(insertChannels.count) канала(ов)")
            }
            
            if let insertMessages = inserts as? Set<DBMessage> {
                print("🟢 \(insertMessages.count) сообщений")
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            
            print("Обновлено объектов: \(updates.count)")
            print("Из них:")
            
            if let updateChannels = updates as? Set<DBChannel> {
                print("🟡 \(updateChannels.count) канала(ов)")
            }
            
            if let updateMessages = updates as? Set<DBMessage> {
                print("🟡 \(updateMessages.count) сообщений")
            }
            
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
            print("Удалено объектов: \(deletes.count)")
            print("Из них:")
            
            if let deleteChannels = deletes as? Set<DBChannel> {
                print("🔴 \(deleteChannels.count) канала(ов)")
            }
            
            if let deleteMessages = deletes as? Set<DBMessage> {
                print("🔴 \(deleteMessages.count) сообщений")
            }
            
        }
        
        print("🆕➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🆕")
        
    }
    
    func printDatabaseStatistics() {
        mainContext.perform {
            do {
                let countOfChannels = try self.mainContext.count(for: DBChannel.fetchRequest())
                
                let countOfMessages = try self.mainContext.count(for: DBMessage.fetchRequest())
                
                print(" ")
                
                print("📶➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖📶")
                print("Статистика (сохранено в базе):")
                print("\(countOfChannels) канала(ов), \(countOfMessages) сообщений")
                print("📶➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖📶")
                
                print(" ")
                print("🔽➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🔽")
                print("Подробнее: ")
                
                let arrayOfChannels = try self.mainContext.fetch(DBChannel.fetchRequest()) as? [DBChannel] ?? []
                
                arrayOfChannels.forEach {
                    print($0.about)
                }
                
                print("🔼➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖🔼")
                
            } catch {
                fatalError(error.localizedDescription)
            }
            
        }
    }
    
    func fetchChannelById(by id: String, in context: NSManagedObjectContext) -> DBChannel? {
        
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", id)
        
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
    
}
