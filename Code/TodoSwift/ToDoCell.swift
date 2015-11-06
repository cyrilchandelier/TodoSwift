//
//  TodoCell.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/10/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import UIKit
import TodoSwiftKit
import TodoSwiftAccessibility

let ToDoCellIdentifier = "ToDoCellID"


class ToDoCell: UITableViewCell, UITextFieldDelegate
{
    // Outlets
    @IBOutlet var completionButton: UIButton!
    @IBOutlet var contentTextField: UITextField!
    
    // Delegate
    var delegate: ToDoCellDelegate?
    
    // Task
    private var task: Task!
    
    // MARK: - Cell lifecyle
    
    override func awakeFromNib()
    {
        // No selection style required
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    // MARK: - Configuration
    
    func configureWithTask(task: Task)
    {
        // Hold task
        self.task = task
        
        // Set button state
        completionButton.selected = task.completed.boolValue
        
        // Set content
        contentTextField.text = task.label
        
        // Accessibility
        completionButton.accessibilityLabel = Accessibility.MarkAsCompletedButton(task.label).localizedLabel
    }
    
    // MARK: - UI Actions
    
    @IBAction func toggleCompleted()
    {
        delegate?.toDoCell(self, didToggleCompletionForTask: task)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Notify delegate
        delegate?.toDoCell(self, didEditContent: textField.text, forTask: task)
        
        // Close keyboard
        textField.resignFirstResponder()
        
        return true
    }
}

protocol ToDoCellDelegate
{
    /**
    Called when user touch the check mark button
    
    - parameter cell: the ToDoCell instance that sends the message
    - parameter task: the Task instance represented by the cell
    */
    func toDoCell(cell: ToDoCell, didToggleCompletionForTask task: Task)
    
    /**
     Called when user finished editing task label
     
     - parameter cell: the ToDoCell instance that sends the message
     - parameter content: the new content entered by the user
     - parameter task: the Task instance represented by the cell
    */
    func toDoCell(cell: ToDoCell, didEditContent content: String?, forTask task: Task)
}