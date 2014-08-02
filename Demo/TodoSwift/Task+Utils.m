//
//  Task+Utils.m
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "Task+Utils.h"



@implementation Task (Utils)

#pragma mark - Sort descriptors
+ (NSArray *)sortDescriptors
{
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:TASK_CREATED_AT_ATTRIBUTE
                                                                         ascending:NO];
    
    return @[ dateSortDescriptor ];
}

#pragma mark - Predicates
+ (NSPredicate *)activePredicate
{
    return [NSPredicate predicateWithFormat:@"%K == %@", TASK_COMPLETED_ATTRIBUTE, @NO];
}

+ (NSPredicate *)completedPredicate
{
    return [NSPredicate predicateWithFormat:@"%K == %@", TASK_COMPLETED_ATTRIBUTE, @YES];
}

@end
