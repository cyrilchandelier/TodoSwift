//
//  TaskControllerCase.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import CoreData
import XCTest



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
        // Delete database
        CoreDataController.sharedInstance.deleteDatabase()
        
        super.tearDown()
    }
    
    func testSingletonSharedInstanceCreated()
    {
        XCTAssertNotNil(TaskController.sharedInstance, "An instance of TaskController class should have been created")
    }
    
    func testEmptyTaskListAtFirstLaunch()
    {
        let taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0)
    }
    
    func testTaskInsertion()
    {
        // Insert a task
        TaskController.sharedInstance.createTask("foo")
        
        // Ensure task has been inserted
        var taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 1, "Task list should contain 1 task")
        
        // Insert another task
        TaskController.sharedInstance.createTask("bar")
        taskList = TaskController.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 2, "Task list should contain 2 tasks")
    }
}
