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
#import "CoreDataHandler.h"
#import "InventoryDataHandler.h"
#import "MD5Hasher.h"

@interface iris_MenuViewController ()
{
    Reachability *internetReachable;
	InventoryDataHandler *dataHandler;
	CoreDataHandler *coreDataHandler;
	MD5Hasher *hashGenerator;
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
	
	// Instantiations
    internetReachable = [[Reachability alloc] init];
	dataHandler = [[InventoryDataHandler alloc] init];
	hashGenerator = [[MD5Hasher alloc] init];
	
	// Run Methods
    [internetReachable checkConnection];
	
	// Check for internet availability
    if (internetReachable.isConnected) {
        NSLog(@"Now witness the firepower of this fully ARMED and OPERATIONAL battle station!");
        [dataHandler downloadInventoryAndActions];
    } else {
        NSLog(@"WHERE IS THE INTERWEBS?");
		_alert = [[UIAlertView alloc]initWithTitle:@"Connection Not Available" message:@"To download and/or update the inventory list you must have a working internet connection. Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
		[_alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
