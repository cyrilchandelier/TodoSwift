//
//  ToDoViewController.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/10/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import UIKit
import CoreData
import TodoSwiftKit

class ToDoViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate, ToDoCellDelegate
{
    // Outlets
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var clearBarButtonItem: UIBarButtonItem!
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var tableFooterView: UIView!
    @IBOutlet var itemsCountLabel: UILabel!
    
    // Data
    private var frc: NSFetchedResultsController!
    private var predicate: NSPredicate? {
        didSet {
            refreshData()
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Accessibility
        tableView.accessibilityLabel = "Tasks list"
        taskTextField.accessibilityLabel = "Create a new task"
        
        // Background color
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_pattern")!)
        
        // i18n
        taskTextField.placeholder = NSLocalizedString("todo_list.task_placeholder", comment: "Add task placeholder")
        segmentedControl.setTitle(NSLocalizedString("todo_list.filter.all", comment: "Filter: All"), forSegmentAtIndex: 0)
        segmentedControl.setTitle(NSLocalizedString("todo_list.filter.active", comment: "Filter: Active"), forSegmentAtIndex: 1)
        segmentedControl.setTitle(NSLocalizedString("todo_list.filter.completed", comment: "Filter: Completed"), forSegmentAtIndex: 2)
        
        // Refresh
        refreshData()
        refreshUI()
    }
    
    // MARK: - Data management
    
    func refreshData()
    {
        // Prepare fetch request
        let fetchRequest = NSFetchRequest(entityName: TaskEntityName)
        fetchRequest.sortDescriptors = Task.sortDescriptors()
        fetchRequest.predicate = predicate
        
        // Create FRC
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataController.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure frc delegate
        frc.delegate = self
        
        // Perform data fetch
        do {
            try frc.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // Refresh UI
        refreshUI();
    }
    
    func refreshUI()
    {
        if !isViewLoaded() {
            return
        }
        
        // Reload table view if loaded
        tableView.reloadData()
        
        // Refresh table view footer
        refreshTableFooterView()
    }
    
    func refreshTableFooterView()
    {
        // Query only active tasks
        let itemsCount = TaskService.taskList(Task.activePredicate()).count
        
        // Build attributed string
        let itemsCountString = NSMutableAttributedString()
        itemsCountString.appendAttributedString(NSAttributedString(string: String(itemsCount), attributes: [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)
            ]))
        itemsCountString.appendAttributedString(NSAttributedString(string: (itemsCount == 1 ? NSLocalizedString("todo_list.item_left", comment: "Singular items left") : NSLocalizedString("todo_list.items_left", comment: "Plural items left")), attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(14.0)
            ]))
        
        // Update label
        itemsCountLabel.attributedText = itemsCountString
        
        // Assign table footer view
        tableView.tableFooterView = tableFooterView
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        guard let sections = frc.sections else {
            return 0
        }
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = frc.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let task = frc.objectAtIndexPath(indexPath) as! Task
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ToDoCellIdentifier) as! ToDoCell
        cell.delegate = self
        cell.configureWithTask(task)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let task = frc.objectAtIndexPath(indexPath) as! Task
            TaskService.deleteTask(task)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        refreshUI()
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        guard let content = textField.text else {
            return false
        }
        
        // Create a task if entered string is not empty
        if content.characters.count > 0 {
            TaskService.createTask(content)
        }
        
        // Reset text field
        textField.text = ""
        
        // Close keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - ToDoCellDelegate methdos
    
    func toDoCell(cell: ToDoCell, didToggleCompletionForTask task: Task)
    {
        TaskService.toggleTask(task)
    }
    
    func toDoCell(cell: ToDoCell, didEditContent content: String?, forTask task: Task)
    {
        guard let content = content else {
            return
        }
        
        TaskService.updateTask(task, content: content)
    }
    
    // MARK: - UI Actions
    
    @IBAction func filter(sender: UISegmentedControl)
    {
        // Update predicate
        switch(sender.selectedSegmentIndex) {
        case 1:
            predicate = Task.activePredicate()
        case 2:
            predicate = Task.completedPredicate()
        case 0:
            fallthrough
        default:
            predicate = nil
        }
        
        // Refresh data
        refreshData()
    }
    
    @IBAction func clearCompleted()
    {
        TaskService.clearCompletedTasks()
    }
    
    // MARK: - Memory management
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

