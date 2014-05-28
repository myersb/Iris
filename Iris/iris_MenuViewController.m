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
#import "iris_InventoryDataHandler.h"

@interface iris_MenuViewController ()
{
    Reachability *internetReachable;
	iris_InventoryDataHandler *dataHandler;
	CoreDataHandler *coreDataHandler;
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
	
	dataHandler = [[iris_InventoryDataHandler alloc] init];
	coreDataHandler = [[CoreDataHandler alloc] init];
	
    if (internetReachable.isConnected) {
        NSLog(@"Now witness the firepower of this fully ARMED and OPERATIONAL battle station!");
        [dataHandler downloadInventoryAndActions];
    } else {
        NSLog(@"WHERE IS THE INTERWEBS?");
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
