//
//  TodayViewController.swift
//  TodoSwift Today Extension
//
//  Created by Cyril Chandelier on 01/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import UIKit
import NotificationCenter
import TodoSwiftKit


class TodayViewController: UIViewController, NCWidgetProviding
{
    // Outlets
    @IBOutlet var countLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void))
    {
        let itemsCount = TaskService.taskList(Task.activePredicate()).count
        
        // Build attributed string
        let itemsCountString = NSMutableAttributedString()
        itemsCountString.appendAttributedString(NSAttributedString(string: String(itemsCount), attributes: [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)
            ]))
        itemsCountString.appendAttributedString(NSAttributedString(string: (itemsCount == 1 ? NSLocalizedString("todo_list.item_left", comment: "Singular items left") : NSLocalizedString("todo_list.items_left", comment: "Plural items left")), attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(14.0)
            ]))
        
        countLabel.attributedText = itemsCountString
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets
    {
        return UIEdgeInsetsZero
    }
    
    @IBAction func widgetTouched()
    {
        self.extensionContext?.openURL(NSURL(string: "todoswift://wakeup")!, completionHandler: nil)
    }
}
