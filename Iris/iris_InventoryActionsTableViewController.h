//
//  iris_InventoryActionsTableViewController.h
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"

@interface iris_InventoryActionsTableViewController : UITableViewController

// Variable Properties
@property (strong, nonatomic) InventoryItem *currentItem;
@property (strong, nonatomic) NSArray *sortedActions;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
