//
//  CoreDataStack.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 23.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    static var shared: CoreDataStack { get }
    
    var writterContext: NSManagedObjectContext { get }
    var mainContext: NSManagedObjectContext { get }
    func saveContext() -> NSManagedObjectContext
}

class CoreDataStack: CoreDataStackProtocol {
    
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
    
    internal lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
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
    
    internal lazy var writterContext: NSManagedObjectContext = {
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
    
    internal func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
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
    
    //NSFetchedResultsController for ConversationListViewController tableView
    lazy var channelsFetchedResultsController: NSFetchedResultsController<DBChannel> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptorByLastActivity = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortDescriptorByLastMessage = NSSortDescriptor(key: "lastMessage", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptorByLastActivity, sortDescriptorByLastMessage]
        
        fetchRequest.fetchBatchSize = 20

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
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
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }
    
}
