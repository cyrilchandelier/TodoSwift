//
//  TodoSwift_UI_Tests.swift
//  TodoSwift UI Tests
//
//  Created by Cyril Chandelier on 05/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import XCTest


class TodoSwift_UI_Tests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testThatClearingCompletedTasksWorks()
    {
        let app = XCUIApplication()
        
        // Find the text field and enter some task text
        let whatNeedsToBeDoneTextField = app.tables["Tasks list"].textFields["Create a new task"]
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText("Say Hello")
        app.buttons["Done"].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
        
        // Mark task as completed
        app.tables.buttons["Mark as completed"].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
        
        // Remove task
        app.navigationBars["TodoSwift.ToDoView"].buttons["Delete"].tap()
        XCTAssertEqual(app.tables.cells.count, 0)
    }
}
