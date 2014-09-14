//
//  TaskExtension.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import Foundation



let TaskEntityName          = "Task"

let TaskCreatedAtAttribute  = "createdAt"
let TaskCompletedAttribute  = "completed"
let TaskLabelAttribute      = "label"



extension Task
{
    
    // MARK: Sort descriptors
    
    class func sortDescriptors() -> [NSSortDescriptor]
    {
        let dateSortDescriptor = NSSortDescriptor(key: TaskCreatedAtAttribute, ascending: false)
        
        return [ dateSortDescriptor ]
    }
    
    // MARK: Predicates
    
    class func activePredicate() -> NSPredicate
    {
        return NSPredicate(format: "%K == %@", TaskCompletedAttribute, false)
    }
    
    class func completedPredicate() -> NSPredicate
    {
        return NSPredicate(format: "%K == %@", TaskCompletedAttribute, true)
    }
}