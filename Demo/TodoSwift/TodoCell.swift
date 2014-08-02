//
//  TodoCell.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import UIKit



let TodoCellId = "TodoCellID"



class TodoCell: UITableViewCell, UITextFieldDelegate
{
    // Outlets
    @IBOutlet var completionButton: UIButton!
    @IBOutlet var contentLabel: UITextField!
    
    // Delegate
    var delegate: ToDoCellDelegate?

    // MARK: - Cell lifecyle
    
    override func awakeFromNib()
    {
        // No selection style required
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    // MARK: - Configuration
    
    func configureWithTask(task: Task)
    {
        // Set button state
        completionButton.selected = task.completed
        
        // Set content
        contentLabel.text = task.label
    }
    
    // MARK: - UI Actions
    
    @IBAction func toggleCompleted()
    {
        delegate?.cellDidToggleCompletion(self)
    }
    
    // MARK: - Utils
    
    class func cellHeightForTask(task: Task) -> CGFloat
    {
        return 60.0
    }
    
    class func cellNib() -> UINib
    {
        return UINib(nibName: "TodoCell", bundle: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        // Notify delegate
        delegate?.cellDidEditTaskContent(self, newContent: textField.text)
        
        // Close keyboard
        textField.resignFirstResponder()
        
        return true
    }
}



@objc protocol ToDoCellDelegate
{
    // Called when user touch the check mark button
    func cellDidToggleCompletion(cell: TodoCell)
    
    // Called when user finished editing task label
    func cellDidEditTaskContent(cell: TodoCell, newContent: String)
}