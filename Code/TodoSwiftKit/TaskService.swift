//
//  TaskService.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 01/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import Foundation
import CoreData


public class TaskService
{
    public class func createTask(content: String) -> Task?
    {
        let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
        
        // Trim content
        let trimmedContent = trimmedContentFrom(content)
        if trimmedContent == "" {
            return nil
        }
        
        // Create task
        let task = NSEntityDescription.insertNewObjectForEntityForName(TaskEntityName, inManagedObjectContext: managedObjectContext) as! Task
        task.createdAt = NSDate()
        task.completed = false
        task.label = trimmedContent
        
        // Save managed object context
        saveContext(managedObjectContext)
        
        return task
    }
    
    public class func updateTask(task: Task, content: String)
    {
        let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
        
        // Trim content
        let trimmedContent = trimmedContentFrom(content)
        
        // Delete task if content is empty, update it otherwise
        if trimmedContent.characters.count == 0
        {
            managedObjectContext.deleteObject(task)
            saveContext(managedObjectContext)
        }
        else
        {
            task.label = trimmedContent
            saveContext(task.managedObjectContext)
        }
    }
    
    public class func deleteTask(task: Task)
    {
        let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
        
        // Delete task from main managed object context
        managedObjectContext.deleteObject(task)
        
        // Save
        saveContext(managedObjectContext)
    }
    
    public class func toggleTask(task: Task)
    {
        task.completed = !task.completed.boolValue
        saveContext(task.managedObjectContext)
    }
    
    public class func taskList(predicate: NSPredicate?) -> [AnyObject]
    {
        let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
        fetchRequest.predicate = predicate
        
        do {
            return try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    public class func clearCompletedTasks()
    {
        clearTasks(Task.completedPredicate())
    }
    
    private class func clearTasks(predicate: NSPredicate?)
    {
        let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
        
        // Build a fetch request to retrieve completed task
        let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
        fetchRequest.predicate = predicate
        
        // Perform query
        do {
            let tasks = try managedObjectContext.executeFetchRequest(fetchRequest)
            for task in tasks {
                managedObjectContext.deleteObject(task as! NSManagedObject)
            }
            saveContext(managedObjectContext)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private class func trimmedContentFrom(string: String) -> String
    {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    private class func saveContext(context: NSManagedObjectContext?)
    {
        do {
            try context?.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}