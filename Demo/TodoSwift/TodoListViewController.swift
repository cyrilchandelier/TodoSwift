//
//  TodoListViewController.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import UIKit
import CoreData



class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, ToDoCellDelegate
{
    // Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var clearBarButtonItem: UIBarButtonItem!
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var tableFooterView: UIView!
    @IBOutlet var itemsCountLabel: UILabel!
    
    // Data
    private var frc: NSFetchedResultsController?
    private var predicate: NSPredicate?
    
    // MARK: - Initializers
    
    init()
    {
        // Super
        super.init(nibName: "TodoListViewController", bundle: nil)
        
        // Initialize data variables
        self.refreshData()
        
        // Register to notifications
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardAnimation:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardAnimation:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - View lifecyle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background"))
        
        // Register nib
        self.tableView.registerNib(TodoCell.cellNib(), forCellReuseIdentifier: TodoCellId)
        
        // Add segmented control to navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        self.navigationItem.rightBarButtonItem = clearBarButtonItem
        
        // i18n
        self.taskTextField.placeholder = NSLocalizedString("todo_list.task_placeholder", comment: "Add task placeholder")
        self.segmentedControl.setTitle(NSLocalizedString("todo_list.filter.all", comment: "Filter: All"), forSegmentAtIndex: 0)
        self.segmentedControl.setTitle(NSLocalizedString("todo_list.filter.active", comment: "Filter: Active"), forSegmentAtIndex: 1)
        self.segmentedControl.setTitle(NSLocalizedString("todo_list.filter.completed", comment: "Filter: Completed"), forSegmentAtIndex: 2)
        
        // Force refresh UI
        self.refreshUI()
    }
    
    func refreshData()
    {
        // Prepare fetch request
        let fetchRequest = NSFetchRequest(entityName: TASK_ENTITY_NAME)
        fetchRequest.sortDescriptors = Task.sortDescriptors()
        fetchRequest.predicate = self.predicate
        
        // Create FRC
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure frc delegate
        frc!.delegate = self
        
        // Perform data fetch
        frc!.performFetch(nil)
        
        // Refresh UI
        self.refreshUI();
    }
    
    func refreshUI()
    {
        if self.isViewLoaded() == false
        {
            return
        }
        
        // Reload table view if loaded
        self.tableView?.reloadData()
        
        // Refresh table view footer
        self.refreshTableFooterView()
    }
    
    func refreshTableFooterView()
    {
        // Query only active tasks
        let fetchRequest = NSFetchRequest(entityName: TASK_ENTITY_NAME)
        fetchRequest.predicate = Task.activePredicate()
        let itemsCount = appDelegate.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil).count
        
        // Build attributed string
        var itemsCountString = NSMutableAttributedString()
        itemsCountString.appendAttributedString(NSAttributedString(string: String(itemsCount), attributes: [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)
            ]))
        itemsCountString.appendAttributedString(NSAttributedString(string: (itemsCount == 1 ? NSLocalizedString("todo_list.item_left", comment: "Singular items left") : NSLocalizedString("todo_list.items_left", comment: "Plural items left")), attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(14.0)
            ]))
        
        // Update label
        self.itemsCountLabel.attributedText = itemsCountString
        
        // Assign table footer view
        self.tableView.tableFooterView = self.tableFooterView
    }
    
    // MARK: - UITableViewSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return frc!.sections.count
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = frc!.sections[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(TodoCellId) as TodoCell
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        let task = frc!.objectAtIndexPath(indexPath) as Task
        return TodoCell.cellHeightForTask(task)
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        // Retrieve task
        let task = frc!.objectAtIndexPath(indexPath) as Task
        
        // Cast cell and configure
        let castedCell = cell as TodoCell
        castedCell.configureWithTask(task)
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            // Retrieve task
            let task = self.frc!.objectAtIndexPath(indexPath) as Task
            
            // Delete it from managed object context
            appDelegate.managedObjectContext?.deleteObject(task)
            
            // Save managed object context
            appDelegate.managedObjectContext?.save(nil)
        }
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        let enteredString = textField.text
        
        // Create a task if entered string is not empty
        if enteredString.utf16Count > 0
        {
            // Create task
            var task: Task = NSEntityDescription.insertNewObjectForEntityForName(TASK_ENTITY_NAME, inManagedObjectContext: appDelegate.managedObjectContext) as Task
            task.createdAt = NSDate()
            task.completed = false
            task.label = textField.text
            
            // Save managed object context
            appDelegate.managedObjectContext?.save(nil)
            
            // Reset textfield
            textField.text = ""
        }
        
        // Close keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath)
    {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Update:
            self.tableView.reloadRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Automatic)
        case NSFetchedResultsChangeType.Move:
            self.tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        self.tableView.endUpdates()
        
        // Refresh table view footer
        self.refreshTableFooterView()
    }
    
    // MARK: - ToDoCellDelegate methods
    
    func cellDidToggleCompletion(cell: TodoCell)
    {
        // FIXME: indexPathForCell() only works if cell is visible, possible crash if you scroll the cell out of the screen
        
        // Retrieve index path
        let indexPath = self.tableView.indexPathForCell(cell)
        
        // Update related task and save
        var task = self.frc!.objectAtIndexPath(indexPath) as Task
        task.completed = !task.completed.boolValue
        task.managedObjectContext.save(nil)
    }
    
    func cellDidEditTaskContent(cell: TodoCell, newContent: String)
    {
        // Retrieve index path
        let indexPath = self.tableView.indexPathForCell(cell)
        
        // Update related task and save
        var task = self.frc!.objectAtIndexPath(indexPath) as Task
        task.label = newContent
        task.managedObjectContext.save(nil)
    }
    
    // MARK: - UI Actions
    @IBAction func filter(sender: UISegmentedControl)
    {
        // Update predicate
        switch(sender.selectedSegmentIndex) {
        case 1:
            self.predicate = Task.activePredicate()
        case 2:
            self.predicate = Task.completedPredicate()
        case 0:
            fallthrough
        default:
            self.predicate = nil
        }
        
        // Refresh data
        self.refreshData()
    }
    
    @IBAction func clearCompleted()
    {
        // Build a fetch request to retrieve completed task
        let fetchRequest = NSFetchRequest(entityName: TASK_ENTITY_NAME)
        fetchRequest.predicate = Task.completedPredicate()
        
        // Perform query
        let tasks = appDelegate.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        // Loop over task to delete them
        for task in tasks as [Task]
        {
            appDelegate.managedObjectContext?.deleteObject(task)
        }
        
        // Save changes
        appDelegate.managedObjectContext?.save(nil)
    }
    
    // MARK: - Notifications
    func keyboardAnimation(notification: NSNotification)
    {
        let userInfo = notification.userInfo
        
        // Get keyboard size
        let beginFrameValue = userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue
        let keyboardBeginFrame = self.view.convertRect(beginFrameValue.CGRectValue(), fromView: nil)
        let endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        let keyboardEndFrame = self.view.convertRect(endFrameValue.CGRectValue(), fromView: nil)
        
        // Animation duration
        let animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSValue
        var animationDuration = 0.0
        animationDurationValue.getValue(&animationDuration)
        
        // Animation curve
        let animationCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSValue
        var animationCurve = UIViewAnimationCurve.Linear
        animationCurveValue.getValue(&animationCurve)
        
        // Prepare animation
        var tableViewFrame = self.tableView.frame
        tableViewFrame.size.height = (keyboardBeginFrame.origin.y - tableViewFrame.origin.y)
        self.tableView.frame = tableViewFrame
        
        // Animate
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: TodoListViewController.animationOptionCurve(fromAnimationCurve: animationCurve), animations: {
            
            var tableViewFrame = self.tableView.frame
            tableViewFrame.size.height = (keyboardEndFrame.origin.y - tableViewFrame.origin.y)
            self.tableView.frame = tableViewFrame
            
            }, completion: nil)
    }
    
    private class func animationOptionCurve(fromAnimationCurve curve: UIViewAnimationCurve) -> UIViewAnimationOptions
    {
        switch (curve) {
        case UIViewAnimationCurve.EaseInOut:
            return UIViewAnimationOptions.CurveEaseInOut;
        case UIViewAnimationCurve.EaseIn:
            return UIViewAnimationOptions.CurveEaseIn;
        case UIViewAnimationCurve.EaseOut:
            return UIViewAnimationOptions.CurveEaseOut;
        case UIViewAnimationCurve.Linear:
            return UIViewAnimationOptions.CurveLinear;
        }
    }
}
