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
	
	NSString *urlString = [NSString stringWithFormat:@"%@", inventoryAndActionsWebservice];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	// Use Main thread to download inventory data
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
	 {
		 if (data.length > 0 && connectionError == nil)
		 {
			 [coreDataHandler clearEntity:@"InventoryObject" withFetchRequest:_fetchRequest];
			 [coreDataHandler clearEntity:@"InventoryAction" withFetchRequest:_fetchRequest];
			 NSLog(@"WE HAS THE DATAS");
			 // Place all jSON data into a dictioanry
			 NSDictionary *inventory = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
			 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
			 [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
			 [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
			 NSString *dateStr;
			 NSDate *formattedDate;
			 for (NSDictionary *inventoryItem in inventory)
			 {
				 // Insert all inventory items into CoreData
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
					 dateStr = NSLocalizedString([inventoryItem objectForKey:@"PurchaseDate"], nil);
					 formattedDate = [formatter dateFromString:dateStr];
					 newItem.purchaseDate = formattedDate;
				 }
				 
				 NSDictionary *actions = [inventoryItem objectForKey:@"MediaInventoryActions"];
				 if ([actions count] == 0) {
					 newItem.currentStatus = @"Check In";
				 } else {
					 for (id actionItem in actions)
					 {
						 // Insert all actions associated with inventory items into CoreData
						 InventoryAction *newAction = [NSEntityDescription insertNewObjectForEntityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
						 newAction.inventoryActionID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"MediaInventoryActionsId"], nil) intValue]];
						 newAction.inventoryObjectID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]];
						 newAction.userPerformingActionExt = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"UserPerformingActionExt"], nil) intValue]];
						 newAction.actionID = [NSNumber numberWithInt:[NSLocalizedString([actionItem objectForKey:@"actionId"], nil) intValue]];
						 newAction.actionDate = [NSDate dateWithTimeIntervalSince1970:[NSLocalizedString([actionItem objectForKey:@"ActionDate"], nil) intValue]];
						 newAction.userPerformingAction = NSLocalizedString([actionItem objectForKey:@"UserPerformingAction"], nil);
						 newAction.userAuthorizingAction =  NSLocalizedString([actionItem objectForKey:@"UserAuthorizingAction"], nil);
						 if (NSLocalizedString([actionItem objectForKey:@"Notes"], nil) == (NSString *)[NSNull null]) {
							 newAction.notes = @"";
						 } else {
							 newAction.notes = NSLocalizedString([actionItem objectForKey:@"Notes"], nil);
						 }
						 newAction.actionLongValue = NSLocalizedString([actionItem objectForKey:@"ActionLongValue"], nil);
						 newItem.currentStatus = NSLocalizedString([actionItem objectForKey:@"ActionLongValue"], nil);
						 [newItem addActionObject:newAction];
						 [newAction setValue:newItem forKeyPath:@"object"];
					 }
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
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"currentStatus" ascending:YES];
	_secondSort = [NSSortDescriptor sortDescriptorWithKey:@"objectDescription" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, _secondSort, nil];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	_fetchedInventoryController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"currentStatus" cacheName:@"Default Search"];
	
	return _fetchedInventoryController;
}

- (NSFetchedResultsController *)loadInventoryWithFetchedResultsControllerWithPredicate:(NSPredicate *)predicate
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	if (_fetchedInventoryController != nil)
	{
		return _fetchedInventoryController;
	}
	
	_fetchRequest = [[NSFetchRequest alloc]init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"currentStatus" ascending:YES];
	_secondSort = [NSSortDescriptor sortDescriptorWithKey:@"objectDescription" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, _secondSort, nil];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	_fetchedInventoryController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"currentStatus" cacheName:@"Default Search"];
	
	return _fetchedInventoryController;
}

#pragma mark - Inventory and Action download

- (NSArray *)loadInventory
{
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"objectDescription" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, nil];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	NSError *error;
	_fetchedInventory = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
	
	return _fetchedInventory;
}

- (NSArray *)loadInventoryActionsByInventoryItem:(InventoryItem *)inventoryItem
{
	InventoryItem *selectedInventoryItem = inventoryItem;
	
	NSSet *actions = selectedInventoryItem.action;
	NSSortDescriptor *actionsSort = [NSSortDescriptor sortDescriptorWithKey:@"inventoryActionID" ascending:YES];
	
	_sortedActions = [actions sortedArrayUsingDescriptors:[NSArray arrayWithObject:actionsSort]];
	
	return _sortedActions;
}

#pragma mark - Inventory Object Methods

- (void)updateInventoryObjectWithID:(int)inventoryObjectId
						 andAssetID:(NSString *)assetID
						andQuantity:(int)quantity
					andSerialNumber:(NSString *)serialNumber
					 andDescription:(NSString *)description
					 andAllowAction:(BOOL)allowActions
						 andRetired:(BOOL)retired
					andPurchaseDate:(NSDate *)purchaseDate
				   andPurchasePrice:(float)purchasePrice
{
	NSLog(@"PurchaseDate: %@", purchaseDate);
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"MediaInventoryObjectsId\":%d,\"Quantity\":%d,\"AssetId\":\"%@\",\"SerialNumber\":\"%@\",\"Description\":\"%@\",\"AllowActions\":%d,\"Retired\":%d,\"PurchaseDate\":\"%@\",\"PurchasePrice\":%0.2f,\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}",inventoryObjectId, quantity, assetID, serialNumber, description, allowActions, retired, purchaseDate, purchasePrice, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"jSONString: %@", jSONString);
	
	// Convert jSON string to data
	NSData *putData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"request: %@", request);
	
	// Set the request url format
	NSString *urlString = [NSString stringWithFormat:@"%@/%d", inventoryAndActionsWebservice, inventoryObjectId];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:putData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	NSLog(@"request: %@", request);
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
	
	// Setup ManagedObjectContext
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	// Fetch specific record
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_predicate = [NSPredicate predicateWithFormat:@"inventoryObjectID = %d", inventoryObjectId];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setPredicate:_predicate];
	
	NSError *error = nil;
	NSArray *inventoryResult = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
	
	// Update record
	InventoryItem *inventoryItem = [inventoryResult objectAtIndex:0];
	inventoryItem.objectDescription = description;
	inventoryItem.assetID = assetID;
	inventoryItem.quantity = [NSNumber numberWithInt:quantity];
	inventoryItem.purchasePrice = [NSNumber numberWithFloat:purchasePrice];
	inventoryItem.purchaseDate = purchaseDate;
	[self.managedObjectContext save:nil];
}

- (void)insertInventoryObjectWithAssetID:(NSString *)assetID
							 andQuantity:(int)quantity
						 andSerialNumber:(NSString *)serialNumber
						  andDescription:(NSString *)description
						  andAllowAction:(BOOL)allowActions
							  andRetired:(BOOL)retired
						 andPurchaseDate:(NSDate *)purchaseDate
						andPurchasePrice:(float)purchasePrice
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"Quantity\":%d,\"AssetId\":\"%@\",\"SerialNumber\":\"%@\",\"Description\":\"%@\",\"AllowActions\":%d,\"Retired\":%d,\"PurchaseDate\":\"%@\",\"PurchasePrice\":%0.2f,\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}", quantity, assetID, serialNumber, description, allowActions, retired, purchaseDate, purchasePrice, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"%@", jSONString);
	
	// Convert jSON string to data
	NSData *postData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSLog(@"%@", postData);
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"Request: %@", request);
	
	// Set the request url format
	NSString *urlString = [NSString stringWithFormat:@"%@", inventoryAndActionsWebservice];
	[request setURL:[NSURL URLWithString:urlString]];
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
	newItem.purchaseDate = purchaseDate;
	newItem.purchasePrice = [NSNumber numberWithFloat:purchasePrice];
	newItem.currentStatus = @"Check In";
	[self.managedObjectContext save:nil];
}

- (void)deleteInventoryObjectWithID:(int)inventoryObjectId
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSLog(@"%@", [NSDate date]);
	NSString *jSONString = [NSString stringWithFormat:@"{\"MediaInventoryObjectsId\":%d,\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}", inventoryObjectId, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"%@", jSONString);
	
	// Convert jSON string to data
	NSData *deleteData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSLog(@"%@", deleteData);
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"Request: %@", request);
	
	// Set the request url format
	NSString *urlString = [NSString stringWithFormat:@"%@/%d", inventoryAndActionsWebservice, inventoryObjectId];
	NSLog(@"%@", urlString);
	
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"DELETE"];
	[request setHTTPBody:deleteData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	NSLog(@"Request: %@", request);
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"returnData: %@", returnData);
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
}


#pragma mark - Inventory Actions Methods
- (void)updateActionWithID:(int)inventoryActionID
	   andActionDate:(NSDate *)actionDate
			andNotes:(NSString *)notes
andUserAuthorizingAction:(NSString *)userAuthorizingAction
andUserPerformingAction:(NSString *)userPerformingAction
andUserPerformingActionExt:(int)extension
andInventoryObjectID:(int)inventoryObjectID
andUserActionID:(int)actionID
		andActionLongValue:(NSString *)actionLongValue
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	NSLog(@"%@", actionLongValue);
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"MediaInventoryActionsId\":%d,\"MediaInventoryObjectsId\":%d,\"UserPerformingActionExt\":%d,\"ActionId\":%d,\"ActionDate\":\"%@\",\"UserPerformingAction\":\"%@\",\"UserAuthorizingAction\":\"%@\",\"Notes\":\"%@\",\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}", inventoryActionID, inventoryObjectID, extension, actionID, [NSDate date], userPerformingAction, userAuthorizingAction, notes, hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"%@", jSONString);
	
	// Convert jSON string to data
	NSData *postData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSLog(@"%@", postData);
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"Request: %@", request);
	
	// Set the request url format
	NSString *urlString = [NSString stringWithFormat:@"%@/%d/actions/%d", inventoryAndActionsWebservice, inventoryObjectID, inventoryActionID];
	NSLog(@"%@", urlString);
	
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody:postData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	NSLog(@"Request: %@", request);
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"returnData: %@", returnData);
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
	
	// Setup ManagedObjectContext
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	// Fetch specific record
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
	_predicate = [NSPredicate predicateWithFormat:@"inventoryActionID = %d", inventoryActionID];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setPredicate:_predicate];
	
	NSError *error = nil;
	NSArray *inventoryResult = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
	
	// Update record
	InventoryAction *inventoryAction = [inventoryResult objectAtIndex:0];
	inventoryAction.actionDate = [NSDate date];
	inventoryAction.actionLongValue = actionLongValue;
	inventoryAction.userAuthorizingAction = userAuthorizingAction;
	inventoryAction.userPerformingAction = userPerformingAction;
	inventoryAction.userPerformingActionExt = [NSNumber numberWithInt:extension];
	inventoryAction.notes = notes;
	[self.managedObjectContext save:nil];
}



- (void)deleteInventoryActionWithInventoryID:(int)inventoryId andActionId:(int)inventoryActionId
{
	// Create values for encryption
	hashGenerator = [[MD5Hasher alloc] init];
	NSDictionary *hashDict = [hashGenerator createHash];
	
	// Setup jSON String
	NSString *jSONString = [NSString stringWithFormat:@"{\"UserInput\":\"%@\",\"GeneratedInput\":\"%@\"}", hashDict[@"userInput"], hashDict[@"generatedInput"]];
	NSLog(@"%@", jSONString);
	
	// Convert jSON string to data
	NSData *deleteData = [jSONString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSLog(@"%@", deleteData);
	
	// Instantiate a url request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	NSLog(@"Request: %@", request);
	
	// Set the request url format
	NSString *urlString = [NSString stringWithFormat:@"%@/%d/actions/%d", inventoryAndActionsWebservice, inventoryId, inventoryActionId];
	NSLog(@"%@", urlString);
	
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"DELETE"];
	[request setHTTPBody:deleteData];
	[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
	NSLog(@"Request: %@", request);
	
	// Send data to the webservice
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"returnData: %@", returnData);
	NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", result);
}

@end
