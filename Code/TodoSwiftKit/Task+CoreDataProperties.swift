//
//  Task+CoreDataProperties.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 01/11/15.
//  Copyright © 2015 Cyril Chandelier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task
{
    @NSManaged public var createdAt: NSDate
    @NSManaged public var completed: NSNumber
    @NSManaged public var label: String
}
