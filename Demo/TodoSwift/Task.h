//
//  Task.h
//  TodoSwift
//
//  Created by Cyril Chandelier on 31/07/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * completed;

@end
