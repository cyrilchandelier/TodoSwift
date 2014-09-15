//
//  TaskControllerCase.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import CoreData
import XCTest



class TaskControllerSingletonCase: XCTestCase
{
    func testSingletonSharedInstanceCreated()
    {
        XCTAssertNotNil(TaskController.sharedInstance, "An instance of TaskController class should have been created")
    }
    
    func testSharedInstanceIsUnique()
    {
        let taskControllerOne = TaskController.sharedInstance
        let taskControllerTwo = TaskController.sharedInstance
        let taskControllerThree = TaskController()
        
        XCTAssert(taskControllerOne === taskControllerTwo, "Shared instance controllers called twice should return the same instance")
        XCTAssert(taskControllerOne !== taskControllerThree, "Separately created task controller should not be equal to shared instance")
    }
}



class TaskControllerCase: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        // Configure CoreData stack
        CoreDataController.sharedInstance.configure("TodoSwift", storeType: NSInMemoryStoreType)
    }
    
    override func tearDown()
    {
        // Clear all tasks from database
        TaskController.sharedInstance.clearTasks(nil)
        
        super.tearDown()
    }
    
    func testTaskClearing()
    {
        // Insert a task
        TaskController.sharedInstance.createTask("foo")
        TaskController.sharedInstance.createTask("bar")
        
        // Clear tasks
        TaskController.sharedInstance.clearTasks(nil)
        
        // Ensure task list is empty
        let taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0, "Task list should not contain any task")
    }
    
    func testEmptyTaskListAtFirstLaunch()
    {
        let taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0)
    }
    
    func testTaskInsertion()
    {
        // Insert a task
        let taskOne = TaskController.sharedInstance.createTask("foo")
        
        // Ensure task has been inserted
        var taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 1, "Task list should contain 1 task")
        
        // Insert another task
        TaskController.sharedInstance.createTask("bar")
        taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 2, "Task list should contain 2 tasks")
    }
    
    func testTaskDeletion()
    {
        // Insert a task
        let task = TaskController.sharedInstance.createTask("foo")
        
        // Delete task
        TaskController.sharedInstance.deleteTask(task!)
        
        // Ensure it was deleted
        let taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0, "Task list should not contain any task")
    }
    
    func testTaskEdition()
    {
        // Insert a task
        let task = TaskController.sharedInstance.createTask("foo")
        XCTAssertEqual(task!.label, "foo", "Task label should be 'foo'")
        
        // Update task
        TaskController.sharedInstance.updateTask(task!, content: "bar")
        
        // Ensure task has been updated
        XCTAssertEqual(task!.label, "bar", "Task label should be 'bar'")
    }
    
    func testTaskLabelIsTrimmed()
    {
        let label = "     Hello, World!  "
        
        // Test trim during insertion
        let task = TaskController.sharedInstance.createTask(label)
        XCTAssertEqual(task!.label, "Hello, World!", "Task label should be 'Hello, World!'")
        
        // Test trim during update
        TaskController.sharedInstance.updateTask(task!, content: label)
        XCTAssertEqual(task!.label, "Hello, World!", "Task label should be 'Hello, World!'")
    }
    
    func testTaskIsNotInsertedIfLabelIsEmpty()
    {
        let label = ""
        
        // Test that task will not be inserted if label is empty
        var task = TaskController.sharedInstance.createTask(label)
        XCTAssertNil(task, "Task should not has been created")
    }
    
    func testTaskIsDeletedIfUpdatedWithEmptyString()
    {
        let label = ""
        
        // Create a task to be updated
        let task = TaskController.sharedInstance.createTask("foo")
        
        // Test that task is deleted if label is empty
        TaskController.sharedInstance.updateTask(task!, content: label)
        let taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0, "Task list should not contain any task")
    }
}
