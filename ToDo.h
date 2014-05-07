//
//  ToDo.h
//  ToDoList
//
//  Created by VP on 5/7/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ToDo : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSNumber * points;

@end
