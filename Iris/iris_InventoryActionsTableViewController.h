//
//  iris_InventoryActionsTableViewController.h
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"
#import "InventoryAction.h"

@interface iris_InventoryActionsTableViewController : UITableViewController

// Core Data Properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSEntityDescription *entity;
@property (strong, nonatomic) NSPredicate *predicate;

// Variable Properties
@property (strong, nonatomic) InventoryAction *action;
@property (strong, nonatomic) InventoryItem *currentItem;
@property (strong, nonatomic) NSMutableSet *objectSet;
@property (strong, nonatomic) NSArray *sortedActions;
@property (strong, nonatomic) NSArray *fetchedResults;
@property (strong, nonatomic) NSManagedObject *objectToDelete;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
