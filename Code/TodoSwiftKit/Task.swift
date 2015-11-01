//
//  Task.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 01/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//

import Foundation
import CoreData


public let TaskEntityName           = "Task"
public let TaskCompletedAttribute   = "completed"
public let TaskCreatedAtAttribute   = "createdAt"
public let TaskLabelAttribute       = "label"


public class Task: NSManagedObject
{
    // MARK: - Sort descriptors
    
    public class func sortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: TaskCreatedAtAttribute, ascending: false)
        ]
    }
    
    // MARK: - Predicates
    
    public class func activePredicate() -> NSPredicate
    {
        return NSPredicate(format: "%K == %@", TaskCompletedAttribute, false)
    }
    
    public class func completedPredicate() -> NSPredicate
    {
        return NSPredicate(format: "%K == %@", TaskCompletedAttribute, true)
    }
}
