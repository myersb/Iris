//
//  iris_InventoryDataHandler.m
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Models Import
#import "InventoryDataHandler.h"
#import "CoreDataHandler.h"

//Data Import
#import "InventoryAction.h"

// Utilities Import
#import "Reachability.h"

#define inventoryAndActionsWebservice @"http://cmhinfo.pubdev.com/api/mediainventory"

@implementation InventoryDataHandler
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
	
	NSString *urlString = [NSString stringWithFormat:@"%@", inventoryAndActionsWebservice];
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
			 [self updateInventoryObjectWithID:1 andAssetID:15 andQuantity:24 andSerialNumber:@"R2D3PO" andDescription:@"Test Camera 12" andAllowAction:true andRetired:false];
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
	
	_fetchedInventoryController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"objectDescription.stringGroupByFirstInitial" cacheName:nil];
	
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

- (NSArray *)loadInventoryActionsByInventoryItem:(InventoryItem *)inventoryItem
{
	InventoryItem *selectedInventoryItem = inventoryItem;
	NSSet *actions = selectedInventoryItem.action;
	NSSortDescriptor *actionsSort = [NSSortDescriptor sortDescriptorWithKey:@"actionID" ascending:YES];
	_sortedActions = [actions sortedArrayUsingDescriptors:[NSArray arrayWithObject:actionsSort]];
	
	return _sortedActions;
}

- (void)updateInventoryObjectWithID:(int)inventoryObjectId andAssetID:(int)assetID andQuantity:(int)quantity andSerialNumber:(NSString *)serialNumber andDescription:(NSString *)description andAllowAction:(BOOL)allowActions andRetired:(BOOL)retired
{
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"MediaInventoryObjectsId\":%d,\"AssetId\":%d,\"Quantity\":%d,\"SerialNumber\":\"%@\",\"Description\":\"%@\",\"AllowActions\":%d,\"Retired\":%d}",inventoryObjectId, assetID, quantity, serialNumber, description, allowActions, retired];
	
	// Convert jSON string to data
	NSData *putData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	// Set the request url format
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", inventoryAndActionsWebservice, inventoryObjectId]]];
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:putData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}

@end
