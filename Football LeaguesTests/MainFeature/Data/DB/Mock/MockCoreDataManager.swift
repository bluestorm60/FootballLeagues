//
//  MockCoreDataManager.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import Foundation
import CoreData
@testable import Football_Leagues

class MockCoreDataManager: CoreDataManagerProtocol {
    var viewContextBackground: NSManagedObjectContext
    
    var persistentContainer: NSPersistentContainer
    var shouldFail = false
    // MARK: - Properties
    private lazy var persistentCoordinator = persistentContainer.persistentStoreCoordinator
    
    // MARK: - Init
    init() {
        persistentContainer = NSPersistentContainer(name: Constants.modelName.rawValue)
        viewContextBackground = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType // Use an in-memory store for testing
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Failed to load in-memory store for testing \(error!)")
            }
            // In-memory store setup is complete
        }
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContextBackground.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContextBackground.parent = viewContext
        
    }
    
    func saveContext(errorCompletion: @escaping (CoreDataError?) -> Void) {
        if shouldFail{
            errorCompletion(CoreDataError.cannotSave)
        }else{
            do {
                try saveBackgroundMode()
                errorCompletion(nil)
            } catch {
                errorCompletion(CoreDataError.objectNotFoundWith(error))
            }
        }
    }
    
    private func saveBackgroundMode() throws {
        if viewContextBackground.hasChanges {
            do {
                try viewContextBackground.save()
                try persistentContainer.viewContext.save()
            } catch {
                throw error
            }
        }
    }
}
