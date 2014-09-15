//
//  CoreDataController.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import Foundation
import CoreData



class CoreDataController
{
    var modelName: String?
    var storeType: String? = NSSQLiteStoreType
    
    var storeUrl: String {
        // At this point, model name should have been set
        assert(self.modelName != nil, "Model name should not be nil")
            
        return modelName! + ".sqlite"
    }
    
    // Shared instance
    class var sharedInstance: CoreDataController {
    struct Static {
        static var instance: CoreDataController?
        static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CoreDataController()
        }
        
        return Static.instance!
    }
    
    // Configuration method
    func configure(modelName: String, storeType: String) {
        self.modelName = modelName
        self.storeType = storeType
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.todoswift") as NSURL!
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // At this point, model name should have been set
        assert(self.modelName != nil, "Model name should not be nil")
        
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName!, withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeUrl)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(self.storeType!, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func deleteDatabase() {
        // Delete database from file system
        NSFileManager.defaultManager().removeItemAtPath(self.storeUrl, error: nil)
    }
}