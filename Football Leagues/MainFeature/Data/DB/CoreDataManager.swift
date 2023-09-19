//
//  CoreDataManager.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 16/09/2023.
//

import CoreData
protocol CoreDataManagerProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var viewContextBackground: NSManagedObjectContext { get }
    
    func saveContext(errorCompletion: @escaping (CoreDataError?)->Void)
}

public class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: - Properties
    public static let shared = CoreDataManager()
    var persistentContainer = NSPersistentContainer(name: Constants.modelName.rawValue)
    var viewContextBackground = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private lazy var persistentCoordinator = persistentContainer.persistentStoreCoordinator

    // MARK: - Init
    init() {
        setPersistentContainer()
    }

    // MARK: - Functions
    private func setPersistentContainer() {
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            print(description.url)
        }
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContextBackground.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContextBackground.parent = viewContext
    }
    
    func saveContext(errorCompletion: @escaping (CoreDataError?)->Void){
        viewContextBackground.performAndWait {
            do{
                try saveBackgroundMode()
            }catch{
                errorCompletion(CoreDataError.fail(error))
            }
        }
    }
    
    private func saveBackgroundMode() throws {
        if viewContextBackground.hasChanges {
            do {
                try viewContextBackground.save()
                try persistentContainer.viewContext.save()
            }
            catch {
                throw error
            }
        }
    }
}
