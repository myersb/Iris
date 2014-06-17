//
//  iris_InventoryTableViewController.m
//  Iris
//
//  Created by Benjamin Myers on 4/24/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Controllers Import
#import "iris_InventoryTableViewController.h"
#import "iris_ItemDetailsViewController.h"

// Models Import
#import "InventoryItem.h"
#import "InventoryAction.h"
#import "InventoryDataHandler.h"

// Utilities Import
#import "Reachability.h"

@interface iris_InventoryTableViewController ()
{
	InventoryDataHandler *dataHandler;
	Reachability *internetReachable;
}
@end

@implementation NSString (FetchedGroupByString)
- (NSString *)stringGroupByFirstInitial {
    if (!self.length || self.length == 1)
        return self;
    return [self substringToIndex:1];
}
@end

@implementation iris_InventoryTableViewController

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
	
    id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	dataHandler = [[InventoryDataHandler alloc] init];
	internetReachable = [[Reachability alloc] init];
	
	NSError *error;
	if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
		NSLog(@"An error has occurred: %@", error);
		abort();
	}
	_fetchedInventoryController = dataHandler.fetchedInventoryController;
	_fetchedInventory = [dataHandler loadInventory];
	_filteredFetchedInventory = [NSMutableArray arrayWithCapacity:[_fetchedInventory count]];
}

-(void)viewDidAppear:(BOOL)animated
{
	_fetchedInventoryController = [dataHandler loadInventoryWithFetchedResultsController];
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
	
	return [[dataHandler.fetchedInventoryController sections]count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//		return [_filteredFetchedInventory count];
//	} else {
		return [[[dataHandler.fetchedInventoryController sections] objectAtIndex:section]
				numberOfObjects];
//	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
 
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if ( cell == nil ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	InventoryItem *inventory = nil;
//	if (tableView == self.searchDisplayController.searchResultsTableView) {
//		inventory = [_filteredFetchedInventory objectAtIndex:indexPath.row];
//	} else {
	inventory = [dataHandler.fetchedInventoryController objectAtIndexPath:indexPath];
//	}
	cell.textLabel.text = inventory.objectDescription;
	if ([inventory.currentStatus isEqualToString:@"Check In"]) {
		cell.detailTextLabel.text = @"Available";
	} else {
		cell.detailTextLabel.text = @"Out";
	}
 
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,320,244)];
	//tempView.backgroundColor=[UIColor clearColor];
	
	UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,320,32)];
	//tempLabel.backgroundColor = [UIColor colorWithRed:(112/255.0) green:(18/255.0) blue:(17/255.0) alpha:1.0];
    tempLabel.backgroundColor = [UIColor darkGrayColor];
	//tempLabel.shadowColor = [UIColor blackColor];
	//tempLabel.shadowOffset = CGSizeMake(0,2);
	tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
	//tempLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
	//tempLabel.font = [UIFont boldSystemFontOfSize:fontSizeForHeaders];
	
	NSString *sectionTitle;
	sectionTitle = [[[dataHandler.fetchedInventoryController sections]objectAtIndex:section]name];
	
	if ([sectionTitle isEqualToString:@"Check In"]) {
		tempLabel.text = @"  Available";
	} else {
		tempLabel.text = @"  Out";
	}
	
	[tempView addSubview:tempLabel];
	
	//[tempLabel release];
	return tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		[self performSegueWithIdentifier:@"segueFromInventoryToInventoryDetails" sender:nil];
    }
    
}

#pragma mark - Search Bar Methods

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        dataHandler.fetchedInventoryController = nil;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectDescription contains[cd] %@", searchText];
        [[dataHandler.fetchedInventoryController fetchRequest] setPredicate:predicate];
    }
	
    NSError *error;
    if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
	
    [[self tableView] reloadData];
}

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

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString: @"segueFromInventoryListToNewInventory"]) {
	
		// Run Methods
		[internetReachable checkConnection];
		
		// Check for internet availability
		if (!internetReachable.isConnected)
		{
			return NO;
			_alert = [[UIAlertView alloc]initWithTitle:@"Connection Not Available" message:@"To download and/or update the inventory list you must have a working internet connection. Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
			[_alert show];
		}
	}
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"segueFromInventoryToInventoryDetails"])
	{
		InventoryItem *selectedInventoryItem = nil;
		iris_ItemDetailsViewController *idvc = [segue destinationViewController];
		if ([self.searchDisplayController isActive])
		{
			_indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			selectedInventoryItem = [dataHandler.fetchedInventoryController objectAtIndexPath:_indexPath];
		} else {
			_indexPath = [self.tableView indexPathForSelectedRow];
			selectedInventoryItem = [dataHandler.fetchedInventoryController objectAtIndexPath:_indexPath];
		}
		idvc.currentInventoryItem = selectedInventoryItem;
	}
}

@end
