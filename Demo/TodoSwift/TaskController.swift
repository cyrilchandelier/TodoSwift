//
//  TaskController.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 13/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import Foundation
import CoreData



class TaskController
{
    // Shared instance
    class var sharedInstance: TaskController
    {
        struct Static
        {
            static var instance: TaskController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
        {
            Static.instance = TaskController()
        }
        
        return Static.instance!
    }
    
    // Create a task with given content
    func createTask(content: String) -> Task?
    {
        // Trim content
        let trimmedContent = content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedContent == ""
        {
            return nil
        }
        
        // Create task
        var task: Task = NSEntityDescription.insertNewObjectForEntityForName(TaskEntityName, inManagedObjectContext: CoreDataController.sharedInstance.managedObjectContext!) as Task
        task.createdAt = NSDate()
        task.completed = false
        task.label = trimmedContent
        
        // Save managed object context
        CoreDataController.sharedInstance.managedObjectContext?.save(nil)
        
        return task
    }
    
    // Update given task with content, trims content before update and delete task if content is empty
    func updateTask(task: Task, content: String)
    {
        // Trim content
        let trimmedContent = content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Delete task if content is empty, update it otherwise
        if trimmedContent.utf16Count == 0
        {
            CoreDataController.sharedInstance.managedObjectContext?.deleteObject(task)
            CoreDataController.sharedInstance.managedObjectContext?.save(nil)
        }
        else
        {
            task.label = trimmedContent
            task.managedObjectContext.save(nil)
        }
    }
    
    // Delete given stask from database
    func deleteTask(task: Task)
    {
        // Delete task from main managed object context
        CoreDataController.sharedInstance.managedObjectContext?.deleteObject(task)
        
        // Save managed object context
        CoreDataController.sharedInstance.managedObjectContext?.save(nil)
    }
    
    // Toggle task status
    func toggleTask(task: Task)
    {
        // Update completion status
        task.completed = !task.completed.boolValue
        
        // Save context
        task.managedObjectContext.save(nil)
    }
    
    // Clear completed task
    func clearCompletedTasks()
    {
        self.clearTasks(Task.completedPredicate())
    }
    
    // Clear tasks
    func clearTasks(predicate: NSPredicate?)
    {
        // Build a fetch request to retrieve completed task
        let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
        fetchRequest.predicate = predicate
        
        // Perform query
        let tasks = CoreDataController.sharedInstance.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        // Loop over task to delete them
        for task in tasks!
        {
            CoreDataController.sharedInstance.managedObjectContext?.deleteObject(task as NSManagedObject)
        }
        
        // Save changes
        CoreDataController.sharedInstance.managedObjectContext?.save(nil)
    }
    
    // Return the filtered task list
    func taskList(predicate: NSPredicate?) -> [AnyObject]?
    {
        let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
        fetchRequest.predicate = predicate
        let items = CoreDataController.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)
        
        return items
    }
}