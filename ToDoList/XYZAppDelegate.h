//
//  XYZAppDelegate.h
//  ToDoList
//
//  Created by VP on 5/7/14.
//
//

#import <UIKit/UIKit.h>

@interface XYZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSMutableArray*) getToDos;
@end
