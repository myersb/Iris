//
//  iris_MenuViewController.m
//  Iris
//
//  Created by Benjamin Myers on 5/21/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_MenuViewController.h"
#import "Reachability.h"
#import "InventoryAction.h"
#import "InventoryItem.h"

#define getInventoryAndActionsWebservice @"http://cmhinfo.pubdev.com/api/mediainventory"
#define updateInventoryObjectWebserivce @"http:http://cmhinfo.pubdev.com/api/mediainventory/"

@interface iris_MenuViewController ()
{
    Reachability *internetReachable;
}
@end

@implementation iris_MenuViewController

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
    // Do any additional setup after loading the view.
	
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
    
    internetReachable = [[Reachability alloc] init];
    [internetReachable checkConnection];
    if (internetReachable.isConnected) {
        NSLog(@"Now witness the firepower of this fully ARMED and OPERATIONAL battle station!");
        [self downloadInventoryAndActions];
    } else {
        NSLog(@"WHERE IS THE INTERWEBS?");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inventory and Action download
- (void)downloadInventoryAndActions
{
	[self clearEntity:@"InventoryObject" withFetchRequest:_fetchRequest];
	[self clearEntity:@"InventoryAction" withFetchRequest:_fetchRequest];
	
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
		   [self loadDetails];
       }
   }];
}

- (void)loadDetails
{
	_fetchRequest = [[NSFetchRequest alloc] init];
	_entity = [NSEntityDescription entityForName:@"InventoryObject" inManagedObjectContext:[self managedObjectContext]];
	_sort = [NSSortDescriptor sortDescriptorWithKey:@"inventoryObjectID" ascending:YES];
	_sortDescriptors = [[NSArray alloc]initWithObjects:_sort, nil];
	
	[_fetchRequest setEntity:_entity];
	[_fetchRequest setSortDescriptors:_sortDescriptors];
	
	NSError *error;
	_fetchedObjects = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
	for (InventoryItem *inventoryItem in _fetchedObjects) {
		NSLog(@"Object Description: %@", [inventoryItem valueForKey:@"objectDescription"]);
		NSLog(@"Object ID: %@", [inventoryItem valueForKey:@"inventoryObjectID"]);
		InventoryAction *action = (InventoryAction *)inventoryItem.action;
		NSLog(@"Action Long Value: %@", [action valueForKey:@"actionLongValue"]);
		NSLog(@"Notes: %@", [action valueForKey:@"notes"]);

	}
}

- (void)updateInventoryObjectWithID:(NSNumber *)inventoryObjectId
{
	NSString *urlString = [NSString stringWithFormat:@"%@%@", updateInventoryObjectWebserivce, inventoryObjectId];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	//NSData *data [NSData data]
	[request setHTTPMethod:@"POST"];
}

- (void)clearEntity:(NSString *)entityName withFetchRequest:(NSFetchRequest *)fetchRequest
{
	fetchRequest = [[NSFetchRequest alloc]init];
	_entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
	
	[fetchRequest setEntity:_entity];
	
	NSError *error = nil;
	NSArray* result = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	for (NSManagedObject *object in result) {
		[[self managedObjectContext] deleteObject:object];
	}
	
	NSError *saveError = nil;
	if (![[self managedObjectContext] save:&saveError]) {
		NSLog(@"An error has occurred: %@", saveError);
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
