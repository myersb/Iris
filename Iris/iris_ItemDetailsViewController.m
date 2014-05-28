//
//  iris_ItemDetailsViewController.m
//  Iris
//
//  Created by Benjamin Myers on 4/29/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_ItemDetailsViewController.h"
#import "iris_InventoryActionsTableViewController.h"

@interface iris_ItemDetailsViewController ()

@end

@implementation iris_ItemDetailsViewController

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
	[self loadInventoryDetails];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInventoryDetails
{
	_lblItemDescription.text = _currentInventoryItem.objectDescription;
	_lblAssetTag.text = [NSString stringWithFormat:@"Asset ID: %@", _currentInventoryItem.assetID];
	
	
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToActionHistory"]) {
		iris_InventoryActionsTableViewController *iatvc = [segue destinationViewController];
		iatvc.currentItem = _currentInventoryItem;
	}
}

@end
