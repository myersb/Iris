//
//  iris_InventoryTableViewController.m
//  Iris
//
//  Created by Benjamin Myers on 4/24/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_InventoryTableViewController.h"
#import "InventoryItem.h"
#import "iris_ItemDetailsViewController.h"
#import "iris_InventoryDataHandler.h"

@interface iris_InventoryTableViewController ()
{
	iris_InventoryDataHandler *dataHandler;
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
	
	dataHandler = [[iris_InventoryDataHandler alloc] init];
	
	NSError *error;
	if (![[dataHandler loadInventoryWithFetchedResultsController] performFetch:&error]) {
		NSLog(@"An error has occurred: %@", error);
		abort();
	}
	
	_fetchedInventory = [dataHandler loadInventory];
	_filteredFetchedInventory = [NSMutableArray arrayWithCapacity:[_fetchedInventory count]];
	
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [_filteredFetchedInventory count];
	} else {
		return [_fetchedInventory count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
 
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if ( cell == nil ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	//Term *term = [self.fetchedResultsController objectAtIndexPath:indexPath];
	InventoryItem *inventory = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		inventory = [_filteredFetchedInventory objectAtIndex:indexPath.row];
	} else {
		inventory = [_fetchedInventory objectAtIndex:indexPath.row];
	}
	cell.textLabel.text = inventory.objectDescription;
 
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
	
	tempLabel.text = [NSString stringWithFormat:@"  %@", sectionTitle];
	
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
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    [self.filteredFetchedInventory removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.objectDescription contains[c] %@", searchText];
    _filteredFetchedInventory = [NSMutableArray arrayWithArray:[_fetchedInventory filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"segueFromInventoryToInventoryDetails"])
	{
		InventoryItem *selectedInventoryItem = nil;
		iris_ItemDetailsViewController *idvc = [segue destinationViewController];
		if ([self.searchDisplayController isActive])
		{
			_indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			selectedInventoryItem = [_filteredFetchedInventory objectAtIndex:_indexPath.row];
		} else {
			_indexPath = [self.tableView indexPathForSelectedRow];
			selectedInventoryItem = [_fetchedInventory objectAtIndex:_indexPath.row];
		}
		idvc.currentInventoryItem = selectedInventoryItem;
	}
}

@end
