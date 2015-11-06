//
//  TodoSwift_UI_Tests.swift
//  TodoSwift UI Tests
//
//  Created by Cyril Chandelier on 05/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import XCTest
import TodoSwiftAccessibility


class TodoSwiftUITests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchEnvironment = [ "UITests" : "true" ]
        app.launch()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testThatClearingCompletedTasksWorks()
    {
        // Given
        let app = XCUIApplication()
        let table = app.tables[Accessibility.TaskList.localizedLabel]
        let whatNeedsToBeDoneTextField = app.textFields[Accessibility.CreateNewTaskTextField.localizedLabel]
        let taskOne = "Say hello..."
        let taskTwo = "...to the world"
        
        // When
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText(taskOne)
        app.buttons["Done"].tap()
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText(taskTwo)
        app.buttons["Done"].tap()
        
        // Then
        XCTAssertEqual(table.cells.count, 2)
        
        // When
        app.buttons[Accessibility.MarkAsCompletedButton(taskOne).localizedLabel].tap()
        
        // Then
        XCTAssertEqual(table.cells.count, 2)
        
        // When
        app.buttons[Accessibility.ClearCompletedTasksButton.localizedLabel].tap()
        
        // Then
        XCTAssertEqual(table.cells.count, 1)
    }
    
    func testThatEmptyStringsDontCreateTasks()
    {
        // Given
        let app = XCUIApplication()
        let table = app.tables[Accessibility.TaskList.localizedLabel]
        let whatNeedsToBeDoneTextField = app.textFields[Accessibility.CreateNewTaskTextField.localizedLabel]
        
        // When
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText("")
        app.buttons["Done"].tap()
        
        // Then
        XCTAssertEqual(table.cells.count, 0)
        
        // When
        whatNeedsToBeDoneTextField.tap()
        whatNeedsToBeDoneTextField.typeText("   ")
        app.buttons["Done"].tap()
        
        // Then
        XCTAssertEqual(table.cells.count, 0)
    }
}
