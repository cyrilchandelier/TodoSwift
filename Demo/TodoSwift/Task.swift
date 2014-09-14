//
//  Task.swift
//  TodoSwift
//
//  Created by Cyril Chandelier on 14/09/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var createdAt: NSDate
    @NSManaged var label: String

}
