//
//  TodoSwift_UI_Tests.swift
//  TodoSwift UI Tests
//
//  Created by Cyril Chandelier on 05/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import XCTest
import TodoSwiftAccessibility


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
        let task = "Say hello"
        
        // Find the text field and enter some task text
        let whatNeedsToBeDoneTextField = app.tables[Accessibility.TaskList.localizedLabel].textFields[Accessibility.CreateNewTaskTextField.localizedLabel]
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText(task)
        app.buttons["Done"].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
        
        // Mark task as completed
        app.tables.buttons[Accessibility.MarkAsCompletedButton(task).localizedLabel].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
        
        // Remove task
        app.navigationBars["TodoSwift.ToDoView"].buttons["Delete"].tap()
        XCTAssertEqual(app.tables.cells.count, 0)
    }
    
    func testThatEmptyStringsDontCreateTasks()
    {
        let app = XCUIApplication()
        
        // Find the text field and enter some task text
        let whatNeedsToBeDoneTextField = app.tables[Accessibility.TaskList.localizedLabel].textFields[Accessibility.CreateNewTaskTextField.localizedLabel]
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText("")
        app.buttons["Done"].tap()
        XCTAssertEqual(app.tables.cells.count, 0)
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText("   ")
        app.buttons["Done"].tap()
        XCTAssertEqual(app.tables.cells.count, 0)
    }
}
