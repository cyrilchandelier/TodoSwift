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
    
    public var localizedLabel: String {
        switch self {
        case .TaskList:
            return localized("accessibility.todo_list.tasks_list", comment: "Accessibility label for the list of tasks")
        case .CreateNewTaskTextField:
            return localized("accessibility.todo_list.create_new_task_textfield", comment: "Accessibility label for the new task text field")
        case .MarkAsCompletedButton(let task):
            return String(format: localized("accessibility.todo_list.mark_as_completed_button", comment: "Accessibility label for the button that marks as task as completed"), task)
        }
    }
    
    private func localized(key: String, comment: String) -> String
    {
        guard let bundle = NSBundle(identifier: "com.cyrilchandelier.TodoSwiftAccessibility") else {
            return ""
        }
        
        return bundle.localizedStringForKey(key, value: nil, table: nil)
    }
}