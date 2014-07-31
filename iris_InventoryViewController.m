//
//  iris_InventoryViewController.m
//  Iris
//
//  Created by Benjamin Myers on 7/7/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_InventoryViewController.h"
#import "iris_ItemDetailsViewController.h"

// Models Import
#import "InventoryAction.h"
#import "InventoryDataHandler.h"

// Utilities Import
#import "Reachability.h"

@interface iris_InventoryViewController ()
{
	InventoryDataHandler *dataHandler;
	Reachability *internetReachable;
}

@end

@implementation iris_InventoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
	_fetchedInventoryController.delegate = self;
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
	
	return [[_fetchedInventoryController sections]count];
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	return [[[_fetchedInventoryController sections] objectAtIndex:section]
			numberOfObjects];
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
	
	inventory = [_fetchedInventoryController objectAtIndexPath:indexPath];
	cell.textLabel.text = inventory.objectDescription;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Asset Tag: %@", inventory.assetID];
	
	
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,320,244)];
	//tempView.backgroundColor = [UIColor colorWithRed:(53/255.0) green:(190/255.0) blue:(132/255.0) alpha:1.0];
	
	UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,320,32)];
	tempLabel.backgroundColor = [UIColor colorWithRed:(53/255.0) green:(190/255.0) blue:(132/255.0) alpha:1.0];
    //tempLabel.backgroundColor = [UIColor darkGrayColor];
	//tempLabel.shadowColor = [UIColor blackColor];
	//tempLabel.shadowOffset = CGSizeMake(0,2);
	tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
	//tempLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
	//tempLabel.font = [UIFont boldSystemFontOfSize:fontSizeForHeaders];
	
	NSString *sectionTitle;
	sectionTitle = [[[_fetchedInventoryController sections]objectAtIndex:section]name];
	
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
        _fetchedInventoryController = nil;
		
		NSError *error;
		if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
			NSLog(@"An error has occurred: %@", error);
			abort();
		}
		_fetchedInventoryController = dataHandler.fetchedInventoryController;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectDescription contains[cd] %@", searchText];
        [[_fetchedInventoryController fetchRequest] setPredicate:predicate];
    }
	
    NSError *error;
    if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
	
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	
	_fetchedInventoryController = nil;
	
	NSError *error;
    if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
	_fetchedInventoryController = dataHandler.fetchedInventoryController;
	
    [self.tableView reloadData];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		_itemToDelete = [_fetchedInventoryController objectAtIndexPath:indexPath];
		NSLog(@"%@", _itemToDelete.inventoryObjectID);
		_alert = [[UIAlertView alloc]initWithTitle:@"Delete Item" message:[NSString stringWithFormat:@"Are you sure that you want to delete %@? This process cannot be undone.", _itemToDelete.objectDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
		[_alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
		// Delete the object that was swiped
		[dataHandler deleteInventoryObjectWithID:[_itemToDelete.inventoryObjectID intValue]];
		[self.managedObjectContext deleteObject:_itemToDelete];
		[self.managedObjectContext save:nil];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
			//        case NSFetchedResultsChangeUpdate:
			//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
			//					atIndexPath:indexPath];
			//            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
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
			selectedInventoryItem = [_fetchedInventoryController objectAtIndexPath:_indexPath];
		} else {
			_indexPath = [self.tableView indexPathForSelectedRow];
			selectedInventoryItem = [_fetchedInventoryController objectAtIndexPath:_indexPath];
		}
		idvc.currentInventoryItem = selectedInventoryItem;
	}
}

@end
