//
//  iris_InventoryDataHandler.h
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventoryItem.h"

@interface InventoryDataHandler : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSFetchedResultsController *fetchedInventoryController;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSArray *sortDescriptors;

// Variable Properties
@property (nonatomic, strong) NSArray *fetchedInventory;
@property (strong, nonatomic) NSArray *sortedActions;

// Actions
- (void)downloadInventoryAndActions;
- (void)updateInventoryObjectWithID:(NSNumber *)inventoryObjectId;
- (NSArray *)loadInventory;
- (NSArray *)loadInventoryActionsByInventoryItem:(InventoryItem *)inventoryItem;
- (NSFetchedResultsController *)loadInventoryWithFetchedResultsController;

@end
