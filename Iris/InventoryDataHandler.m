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
#import "InventoryItem.h"

// Utilities Import
#import "Reachability.h"
#import "MD5Hasher.h"

#define inventoryAndActionsWebservice @"http://cmhinfo.pubdev.com/api/mediainventory"

@implementation InventoryDataHandler
{
	CoreDataHandler *coreDataHandler;
	Reachability *internetReachable;
	MD5Hasher *hashGenerator;
}

// This is only called if there is internect connectivity
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
			 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
			 [formatter setDateFormat:@"yyyy-MM-dd"];
			 NSString *dateStr;
			 for (NSDictionary *inventoryItem in inventory)
			 {
				 InventoryItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
				 dateStr = NSLocalizedString([inventoryItem objectForKey:@"PurchaseDate"], nil);
				 newItem.inventoryObjectID = [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]];
				 newItem.assetID = NSLocalizedString([inventoryItem objectForKey:@"AssetId"], nil);
				 newItem.quantity = [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"Quantity"], nil) intValue]];
				 newItem.serialNumber =  NSLocalizedString([inventoryItem objectForKey:@"SerialNumber"], nil);
				 newItem.objectDescription = NSLocalizedString([inventoryItem objectForKey:@"Description"], nil);
				 newItem.allowsActions = [NSNumber numberWithBool:[NSLocalizedString([inventoryItem objectForKey:@"AllowActions"], nil) boolValue]];
				 newItem.retired = [NSNumber numberWithBool:[NSLocalizedString([inventoryItem objectForKey:@"Retired"], nil) boolValue]];
				 if (NSLocalizedString([inventoryItem objectForKey:@"PurchasePrice"], nil) == (NSString *)[NSNull null]) {
					 newItem.purchasePrice = 0;
				 } else {
					 newItem.purchasePrice = [NSNumber numberWithFloat:[NSLocalizedString([inventoryItem objectForKey:@"PurchasePrice"], nil) floatValue]];
				 }
				 if (NSLocalizedString([inventoryItem objectForKey:@"PurchaseDate"], nil) == (NSString *)[NSNull null]) {
					 newItem.purchaseDate = [NSDate date];
				 } else {
					 newItem.purchaseDate = [formatter dateFromString:dateStr];
				 }
				 
				 NSDictionary *actions = [inventoryItem objectForKey:@"MediaInventoryActions"];
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

- (void)updateInventoryObjectWithID:(int)inventoryObjectId andAssetID:(NSString *)assetID andQuantity:(int)quantity andSerialNumber:(NSString *)serialNumber andDescription:(NSString *)description andAllowAction:(BOOL)allowActions andRetired:(BOOL)retired andPurchaseDate:(NSDate *)purchaseDate andPurchasePrice:(float)purchasePrice
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"MediaInventoryObjectsId\":%d,\"Quantity\":%d,\"AssetId\":\"%@\",\"SerialNumber\":\"%@\",\"Description\":\"%@\",\"AllowActions\":%d,\"Retired\":%d,\"PurchaseDate\":\"%@\",\"PurchasePrice\":%f,\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}",inventoryObjectId, quantity, assetID, serialNumber, description, allowActions, retired, @"2014-06-05T13:43:45.03", purchasePrice, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"jSONString: %@", jSONString);
	// Convert jSON string to data
	NSData *putData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"request: %@", request);
	// Set the request url format
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", inventoryAndActionsWebservice, inventoryObjectId]]];
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:putData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	
	NSLog(@"request: %@", request);
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
}

- (void)insertInventoryObjectWithAssetID:(NSString *)assetID andQuantity:(int)quantity andSerialNumber:(NSString *)serialNumber andDescription:(NSString *)description andAllowAction:(BOOL)allowActions andRetired:(BOOL)retired andPurchaseDate:(NSDate *)purchaseDate andPurchasePrice:(float)purchasePrice
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"Quantity\":%d,\"AssetId\":\"%@\",\"SerialNumber\":\"%@\",\"Description\":\"%@\",\"AllowActions\":%d,\"Retired\":%d,\"PurchaseDate\":\"%@\",\"PurchasePrice\":%f,\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}", quantity, assetID, serialNumber, description, allowActions, retired, @"2014-06-05T13:43:45.03", purchasePrice, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"%@", jSONString);
	// Convert jSON string to data
	NSData *postData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSLog(@"%@", postData);
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"Request: %@", request);
	// Set the request url format
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", inventoryAndActionsWebservice]]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	NSLog(@"Request: %@", request);
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"returnData: %@", returnData);
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
	
	// Insert Into CoreData
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	InventoryItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	newItem.objectDescription = description;
	newItem.assetID = assetID;
	newItem.quantity = [NSNumber numberWithInt:quantity];
	newItem.serialNumber = serialNumber;
	newItem.allowsActions = [NSNumber numberWithBool:allowActions];
	newItem.retired = [NSNumber numberWithBool:retired];
	newItem.purchaseDate = [NSDate date];
	newItem.purchasePrice = [NSNumber numberWithFloat:purchasePrice];
	[self.managedObjectContext save:nil];
	
}

@end
