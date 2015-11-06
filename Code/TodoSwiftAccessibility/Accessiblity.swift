//
//  Accessiblity.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 06/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import Foundation


public enum Accessibility
{
    case TaskList
    case CreateNewTaskTextField
    case MarkAsCompletedButton(String)
    case ClearCompletedTasksButton
    
    public var localizedLabel: String {
        switch self {
        case .TaskList:
            return localize("accessibility.todo_list.tasks_list")
        case .CreateNewTaskTextField:
            return localize("accessibility.todo_list.create_new_task_textfield")
        case .MarkAsCompletedButton(let task):
            return String(format: localize("accessibility.todo_list.mark_as_completed_button"), task)
        case .ClearCompletedTasksButton:
            return localize("accessibility.todo_list.clear_completed_tasks")
        }
    }
    
    private func localize(key: String) -> String
    {
        guard let bundle = NSBundle(identifier: "com.cyrilchandelier.TodoSwiftAccessibility") else {
            return key
        }
        
        return bundle.localizedStringForKey(key, value: nil, table: nil)
    }
}