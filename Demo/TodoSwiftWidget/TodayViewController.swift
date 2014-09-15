//
//  TodayViewController.swift
//  TodoSwiftWidget
//
//  Created by Cyril Chandelier on 15/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData



class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var itemsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure CoreDataController
        CoreDataController.sharedInstance.configure("TodoSwift", storeType: NSSQLiteStoreType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        
        // Query only active tasks
        let itemsCount = TaskController.sharedInstance.taskList(Task.activePredicate())!.count
        
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

        // Trigger completion handler
        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func widgetTouched() {
        self.extensionContext?.openURL(NSURL(string: "todoswift://wakeup"), completionHandler: nil)
    }
    
}
