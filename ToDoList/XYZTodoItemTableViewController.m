//
//  XYZTodoItemTableViewController.m
//  ToDoList
//
//  Created by VP on 5/7/14.
//
//

#import "XYZTodoItemTableViewController.h"
#import "XYZToDoItem.h"
#import "XYZAddToDoItemViewController.h"
#import "ToDo.h"
#import "XYZAppDelegate.h"

@interface XYZTodoItemTableViewController ()
@property NSMutableArray *toDoItems;
@property (weak, nonatomic) IBOutlet UILabel *pointsDisplay;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property XYZAppDelegate *appDelegate;

@end

@implementation XYZTodoItemTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    XYZAddToDoItemViewController *source = [segue sourceViewController];
    XYZToDoItem *item = source.toDoItem;
    if(item != nil){
        [self addItem:item];
    }
}

- (void) addItem:(XYZToDoItem *) item {
    ToDo * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo"
                                                    inManagedObjectContext:self.managedObjectContext];
    newEntry.completed = NO;
    newEntry.itemName = item.itemName;
    newEntry.created = [NSDate date];
    newEntry.modified = [NSDate date];
    newEntry.points = 0;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    [self loadInitialData];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (XYZToDoItem*) translateModel:(ToDo*) todo
{
    XYZToDoItem *item = [[XYZToDoItem alloc] init];
    item.itemName = todo.itemName;
    item.completed = NO;
    if(todo.completed.intValue == 1){
        item.completed = YES;
    }
    item.created = todo.created;
    item.modified = todo.modified;
    item.points = todo.points;
    item.objectID = [todo objectID];
    return item;
}

- (ToDo*) selectOne:(NSManagedObjectID*) objectID
{
    NSError *error = nil;
    ToDo *item = (ToDo*)[self.managedObjectContext existingObjectWithID:objectID error:&error];
    return item;
}

-(void) loadInitialData
{
    self.toDoItems = [[NSMutableArray alloc] init];
    NSMutableArray* items = [self.appDelegate getToDos];
    int i = 0;
    for(i = 0; i < [items count]; i++){
        NSLog(@"Adding item #%d to todos.", i);
        XYZToDoItem *item = [[XYZToDoItem alloc] init];
        item = [self translateModel:[items objectAtIndex:i]];
        [self.toDoItems addObject:item];
    }
    NSLog(@"There are %d todo items in the DB.", [items count]);
    NSLog(@"There are %d todo items from the DB.", [self.toDoItems count]);

    if([self.toDoItems count] == 0){
        XYZToDoItem *itemOne = [[XYZToDoItem alloc] init];
        itemOne.itemName = @"Add some Todo Items!";
        [self.toDoItems addObject:itemOne];
    }
    
    [self updatePoints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (void) updatePoints{
    int i = 0;
    int points = 0;
    for(i = 0; i < [self.toDoItems count]; i++){
        XYZToDoItem* item = (XYZToDoItem *)[self.toDoItems objectAtIndex:i];
        points = points + [item.points intValue];
    }
    self.pointsDisplay.text = [NSString stringWithFormat:@"Points %d", points];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    XYZToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    
    if(toDoItem.completed){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XYZToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    if(tappedItem.completed){
        tappedItem.points = @100;
    }
    else {
        tappedItem.points = @0;
    }
    ToDo *todo = [self selectOne:tappedItem.objectID];
    NSNumber* completed = @0;
    if(tappedItem.completed){
        completed = @1;
    }
    todo.completed = completed;
    todo.points = tappedItem.points;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    [self updatePoints];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:


@end
