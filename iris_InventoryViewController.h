//
//  iris_InventoryViewController.h
//  Iris
//
//  Created by Benjamin Myers on 7/7/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"

@interface iris_InventoryViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSFetchedResultsController *fetchedInventoryController;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSArray *sortDescriptors;

// UI Properties
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Variable Properties
@property (nonatomic, strong) NSArray *fetchedInventory;
@property (nonatomic, strong) NSMutableArray *filteredFetchedInventory;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) NSArray *sortedActions;
@property (nonatomic, strong) InventoryItem *itemToDelete;


@end
