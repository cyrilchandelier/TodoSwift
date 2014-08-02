//
//  Task+Utils.h
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "Task.h"



#define TASK_ENTITY_NAME            @"Task"

#define TASK_CREATED_AT_ATTRIBUTE   @"createdAt"
#define TASK_COMPLETED_ATTRIBUTE    @"completed"
#define TASK_LABEL_ATTRIBUTE        @"label"



@interface Task (Utils)

// Sort descriptors
+ (NSArray *)sortDescriptors;

// Predicates
+ (NSPredicate *)activePredicate;
+ (NSPredicate *)completedPredicate;

@end
