//
//  TaskManager.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 13/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import Foundation

class TaskManager
{
    // Shared instance
    class var sharedInstance: TaskManager {
        struct Static {
            static var instance: TaskManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = TaskManager()
        }
        
        return Static.instance!
    }
    
    // Create a task with given content
    func createTask(content: String)
    {
        // Create task
        var task: Task = NSEntityDescription.insertNewObjectForEntityForName(TASK_ENTITY_NAME, inManagedObjectContext: appDelegate.managedObjectContext!) as Task
        task.createdAt = NSDate()
        task.completed = false
        task.label = content
        
        // Save managed object context
        appDelegate.managedObjectContext?.save(nil)
    }
    
    // Update given task with content, trims content before update and delete task if content is empty
    func updateTask(task: Task, content: String)
    {
        // Trim content
        let trimmedContent = content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Delete task if content is empty, update it otherwise
        if trimmedContent.utf16Count == 0
        {
            appDelegate.managedObjectContext?.deleteObject(task)
            appDelegate.managedObjectContext?.save(nil)
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
        appDelegate.managedObjectContext?.deleteObject(task)
        
        // Save managed object context
        appDelegate.managedObjectContext?.save(nil)
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
        // Build a fetch request to retrieve completed task
        let fetchRequest = NSFetchRequest(entityName: TASK_ENTITY_NAME)
        fetchRequest.predicate = Task.completedPredicate()
        
        // Perform query
        let tasks = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        // Loop over task to delete them
        for task in tasks as [Task]
        {
            appDelegate.managedObjectContext?.deleteObject(task)
        }
        
        // Save changes
        appDelegate.managedObjectContext?.save(nil)
    }
    
    // Return the filtered task list
    func taskList(predicate: NSPredicate?) -> [AnyObject]?
    {
        let fetchRequest = NSFetchRequest(entityName: TASK_ENTITY_NAME)
        fetchRequest.predicate = predicate
        let items = appDelegate.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)
        
        return items
    }
}