//
//  TaskManagerCase.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import UIKit
import XCTest

class TaskManagerCase: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testSingletonSharedInstanceCreated()
    {
        XCTAssertNotNil(TaskManager.sharedInstance, "An instance of TaskManager class should have been created")
    }
    
    func testEmptyTaskListAtFirstLaunch()
    {
        let taskList = TaskManager.sharedInstance.taskList(nil)
        XCTAssertEqual(taskList!.count, 0)
    }
}
