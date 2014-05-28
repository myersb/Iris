//
//  iris_InventoryTableViewController.h
//  Iris
//
//  Created by Benjamin Myers on 4/24/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_InventoryTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSFetchedResultsController *fetchedInventoryController;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSArray *sortDescriptors;

// UI Properties
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

// Variable Properties
@property (nonatomic, strong) NSArray *fetchedInventory;
@property (nonatomic, strong) NSMutableArray *filteredFetchedInventory;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
