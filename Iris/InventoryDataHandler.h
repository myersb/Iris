//
//  iris_InventoryDataHandler.h
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventoryItem.h"

@interface InventoryDataHandler : NSObject <NSURLConnectionDelegate, UIAlertViewDelegate>

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSFetchedResultsController *fetchedInventoryController;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSSortDescriptor *secondSort;
@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, strong) NSPredicate *predicate;

// UI Properties
@property (nonatomic, strong) UIAlertView *alert;

// Variable Properties
@property (nonatomic, strong) NSArray *fetchedInventory;
@property (strong, nonatomic) NSArray *sortedActions;

// Actions
- (void)downloadInventoryAndActions;
- (void)updateInventoryObjectWithID:(int)inventoryObjectId andAssetID:(NSString *)assetID andQuantity:(int)quantity andSerialNumber:(NSString *)serialNumber andDescription:(NSString *)description andAllowAction:(BOOL)allowActions andRetired:(BOOL)retired andPurchaseDate:(NSDate *)purchaseDate andPurchasePrice:(float)purchasePrice;
- (void)insertInventoryObjectWithAssetID:(NSString *)assetID andQuantity:(int)quantity andSerialNumber:(NSString *)serialNumber andDescription:(NSString *)description andAllowAction:(BOOL)allowActions andRetired:(BOOL)retired andPurchaseDate:(NSDate *)purchaseDate andPurchasePrice:(float)purchasePrice;
- (void)deleteInventoryObjectWithID:(int)inventoryObjectId;
- (void)deleteInventoryActionWithInventoryID:(int)inventoryId andActionId:(int)inventoryActionId;
- (NSArray *)loadInventory;
- (NSArray *)loadInventoryActionsByInventoryItem:(InventoryItem *)inventoryItem;
- (NSFetchedResultsController *)loadInventoryWithFetchedResultsController;
- (NSFetchedResultsController *)loadInventoryWithFetchedResultsControllerWithPredicate:(NSPredicate *)predicate;
- (void)updateActionWithID:(int)inventoryActionID andActionDate:(NSDate *)actionDate andNotes:(NSString *)notes andUserAuthorizingAction:(NSString *)userAuthorizingAction andUserPerformingAction:(NSString *)userPerformingAction andUserPerformingActionExt:(int)extension andInventoryObjectID:(int)inventoryObjectID andUserActionID:(int)actionID andActionLongValue:(NSString *)actionLongValue;

@end
