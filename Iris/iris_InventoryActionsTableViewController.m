//
//  iris_InventoryActionsTableViewController.m
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Controllers Import
#import "iris_InventoryActionsTableViewController.h"
#import "iris_ActionDetailsViewController.h"

// Models Import
#import "InventoryDataHandler.h"

@interface iris_InventoryActionsTableViewController ()
{
	InventoryDataHandler *dataHandler;
}
@end

@implementation iris_InventoryActionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    dataHandler = [[InventoryDataHandler alloc] init];
	_sortedActions = [dataHandler loadInventoryActionsByInventoryItem:_currentItem];
	
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
}

-(void)viewDidAppear:(BOOL)animated
{
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_sortedActions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if ( cell == nil ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	_action = [_sortedActions objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = _action.actionLongValue;
	cell.detailTextLabel.text = _action.userPerformingAction;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
		_action = [_sortedActions objectAtIndex:indexPath.row];
		_fetchRequest = [[NSFetchRequest alloc] init];
		_entity = [NSEntityDescription entityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
		_predicate = [NSPredicate predicateWithFormat:@"inventoryActionID == %@", _action.inventoryActionID];
		NSLog(@"%@", _action.inventoryActionID);
		
		[_fetchRequest setEntity:_entity];
		[_fetchRequest setPredicate:_predicate];
		
		NSError *error;
		_fetchedResults = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
		
		_objectToDelete = [_fetchedResults objectAtIndex:0];
		
		[[self managedObjectContext] deleteObject:_objectToDelete];
		[self.managedObjectContext save:nil];
		[dataHandler loadInventoryActionsByInventoryItem:_currentItem];
		[dataHandler deleteInventoryActionWithInventoryID:[_currentItem.inventoryObjectID intValue] andActionId:[_action.inventoryActionID intValue]];
		
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
	[tableView endUpdates];
	[tableView reloadData];
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	iris_ActionDetailsViewController *advc = [segue destinationViewController];
	if ([[segue identifier] isEqualToString:@"segueToActionDetails"])
	{
		_indexPath = [self.tableView indexPathForSelectedRow];
		advc.action = [_sortedActions objectAtIndex:_indexPath.row];
		advc.currentItem = _currentItem;
	}
}

@end
