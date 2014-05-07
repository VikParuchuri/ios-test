//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by VP on 5/7/14.
//
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject
@property NSString *itemName;
@property BOOL completed;
@property NSDate *created;
@property NSDate *modified;
@property NSNumber *points;
@property NSManagedObjectID *objectID;
@end
