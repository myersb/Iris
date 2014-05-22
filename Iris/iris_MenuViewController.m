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

#define inventoryAndActionsWebservice @"http://cmhinfo.pubdev.com/api/mediainventory"

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
{   NSString *urlString = [NSString stringWithFormat:@"%@",inventoryAndActionsWebservice];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
       if (data.length > 0 && connectionError == nil)
       {
           NSLog(@"WE HAS THE DATAS");
           NSDictionary *inventory = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
           for (NSDictionary *inventoryItem in inventory) {
               NSLog(@"/----------------- New Inventory Item -----------------/");
               NSLog(@"MediaInventoryObjectsId: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]]);
               NSLog(@"AssetId: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"AssetId"], nil) intValue]]);
               NSLog(@"Quantity: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"Quantity"], nil) intValue]]);
               NSLog(@"SerialNumber: %@", NSLocalizedString([inventoryItem objectForKey:@"SerialNumber"], nil));
               NSLog(@"Description: %@", NSLocalizedString([inventoryItem objectForKey:@"Description"], nil));
               NSLog(@"AllowActions: %d", [[inventoryItem objectForKey:@"AllowActions"] boolValue]);
               NSLog(@"Retired: %d", [[inventoryItem objectForKey:@"Retired"] boolValue]);
               NSDictionary *actions = [inventoryItem objectForKey:@"Actions"];
               for (id actionItem in actions) {
                   NSLog(@"/**** New Action Item ****/");
                   NSLog(@"MediaInventoryActionsId: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"MediaInventoryActionsId"], nil) intValue]]);
                   NSLog(@"MediaInventoryObjectsId: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"MediaInventoryObjectsId"], nil) intValue]]);
                   NSLog(@"UserPerformingActionExt: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"UserPerformingActionExt"], nil) intValue]]);
                   NSLog(@"UserActionId: %@", [NSNumber numberWithInt:[NSLocalizedString([inventoryItem objectForKey:@"UserActionId"], nil) intValue]]);
                   NSLog(@"ActionDate: %@", [NSDate dateWithTimeIntervalSince1970:[NSLocalizedString([inventoryItem objectForKey:@"ActionDate"], nil) intValue]]);
                   NSLog(@"UserPerformingAction: %@", NSLocalizedString([actionItem objectForKey:@"UserPerformingAction"], nil));
                   NSLog(@"UserAuthorizingAction: %@", NSLocalizedString([actionItem objectForKey:@"UserAuthorizingAction"], nil));
                   NSLog(@"Notes: %@", NSLocalizedString([actionItem objectForKey:@"Notes"], nil));
                   NSLog(@"ActionShortValue: %@", NSLocalizedString([actionItem objectForKey:@"ActionShortValue"], nil));
                   NSLog(@"ActionLongValue: %@", NSLocalizedString([actionItem objectForKey:@"ActionLongValue"], nil));
                   
                   NSLog(@"/**** End Action Item ****/");
               }
               NSLog(@"/----------------- End Inventory Item -----------------/");
           }
       }
   }];
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
