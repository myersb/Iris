//
//  iris_InventoryDataHandler.m
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_InventoryDataHandler.h"
#import "InventoryItem.h"
#import "InventoryAction.h"
#import "CoreDataHandler.h"
#import "Reachability.h"

#define getInventoryAndActionsWebservice @"http://cmhinfo.pubdev.com/api/mediainventory"
#define updateInventoryObjectWebserivce @"http:http://cmhinfo.pubdev.com/api/mediainventory/"

@implementation iris_InventoryDataHandler
{
	CoreDataHandler *coreDataHandler;
	Reachability *internetReachable;
}

- (void)downloadInventoryAndActions
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	coreDataHandler = [[CoreDataHandler alloc] init];
	[coreDataHandler clearEntity:@"InventoryObject" withFetchRequest:_fetchRequest];
	[coreDataHandler clearEntity:@"InventoryAction" withFetchRequest:_fetchRequest];
	
	NSString *urlString = [NSString stringWithFormat:@"%@", getInventoryAndActionsWebservice];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
	 {
		 if (data.length > 0 && connectionError == nil)
		 {
			 NSLog(@"WE HAS THE DATAS");
			 NSDictionary *inventory = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
			 for (NSDictionary *inventoryItem in inventory)
			 {
				 InventoryItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
				 newItem.inventoryObjectID = [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]];
				 newItem.assetID = [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"AssetId"], nil) intValue]];
				 newItem.quantity = [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"Quantity"], nil) intValue]];
				 newItem.serialNumber =  NSLocalizedString([inventoryItem objectForKey:@"SerialNumber"], nil);
				 newItem.objectDescription = NSLocalizedString([inventoryItem objectForKey:@"Description"], nil);
				 newItem.allowsActions = [NSNumber numberWithBool:[NSLocalizedString([inventoryItem objectForKey:@"AllowActions"], nil) boolValue]];
				 newItem.retired = [NSNumber numberWithBool:[NSLocalizedString([inventoryItem objectForKey:@"Retired"], nil) boolValue]];
				 
				 NSDictionary *actions = [inventoryItem objectForKey:@"Actions"];
				 for (id actionItem in actions)
				 {
					 InventoryAction *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
					 newAction.actionID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"MediaInventoryActionsId"], nil) intValue]];
					 newAction.inventoryObjectID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]];
					 newAction.userPerformingActionExt = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"UserPerformingActionExt"], nil) intValue]];
					 newAction.userActionID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"UserActionId"], nil) intValue]];
					 newAction.actionDate = [NSDate dateWithTimeIntervalSince1970:[NSLocalizedString([actionItem objectForKey:@"ActionDate"], nil) intValue]];
					 newAction.userPerformingAction = NSLocalizedString([actionItem objectForKey:@"UserPerformingAction"], nil);
					 newAction.userAuthorizingAction =  NSLocalizedString([actionItem objectForKey:@"UserAuthorizingAction"], nil);
					 if (NSLocalizedString([actionItem objectForKey:@"Notes"], nil) == (NSString *)[NSNull null]) {
						 newAction.notes = @"";
					 } else {
						 newAction.notes = NSLocalizedString([actionItem objectForKey:@"Notes"], nil);
					 }
					 newAction.actionShortValue = NSLocalizedString([actionItem objectForKey:@"ActionShortValue"], nil);
					 newAction.actionLongValue = NSLocalizedString([actionItem objectForKey:@"ActionLongValue"], nil);
					 [newItem addActionObject:newAction];
					 [newAction setValue:newItem forKeyPath:@"object"];
				 }
			 }
			 NSError *error;
			 [self.managedObjectContext save:&error];
		 }
	 }];
}

- (NSFetchedResultsController *) loadInventoryWithFetchedResultsController
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	if (_fetchedInventoryController != nil)
	{
		return _fetchedInventoryController;
	}
	
	_fetchRequest = [[NSFetchRequest alloc]init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"objectDescription" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, nil];
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	_fetchedInventoryController = [[NSFetchedResultsController alloc]initWithFetchRequest:_fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"objectDescription.stringGroupByFirstInitial" cacheName:nil];
	
	return _fetchedInventoryController;
}

#pragma mark - Inventory and Action download

- (NSArray *)loadInventory
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"inventoryObjectID" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, nil];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	NSError *error;
	_fetchedInventory = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
//	for (InventoryItem *inventoryItem in _fetchedInventory) {
//		NSLog(@"Object Description: %@", [inventoryItem valueForKey:@"objectDescription"]);
//		NSLog(@"Object ID: %@", [inventoryItem valueForKey:@"inventoryObjectID"]);
//		NSSet *actions = inventoryItem.action;
//		NSSortDescriptor *actionsSort = [NSSortDescriptor sortDescriptorWithKey:@"actionID" ascending:YES];
//		NSArray *sortedActions = [actions sortedArrayUsingDescriptors:[NSArray arrayWithObject:actionsSort]];
//		NSLog(@"/*********** ACTIONS ***********/");
//		for (InventoryAction *action in sortedActions) {
//			NSLog(@"Action Long Value: %@", [action valueForKey:@"actionLongValue"]);
//			NSLog(@"Notes: %@", [action valueForKey:@"notes"]);
//			NSLog(@"Action ID: %@", [action valueForKey:@"actionID"]);
//		}
//		
//	}
	
	return _fetchedInventory;
}

- (void)updateInventoryObjectWithID:(NSNumber *)inventoryObjectId
{
	NSString *urlString = [NSString stringWithFormat:@"%@%@", updateInventoryObjectWebserivce, inventoryObjectId];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	//NSData *data [NSData data]
	[request setHTTPMethod:@"POST"];
}

@end
