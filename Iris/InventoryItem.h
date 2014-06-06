//
//  InventoryItem.h
//  Iris
//
//  Created by Benjamin Myers on 6/5/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryAction;

@interface InventoryItem : NSManagedObject

@property (nonatomic, retain) NSNumber * allowsActions;
@property (nonatomic, retain) NSString * assetID;
@property (nonatomic, retain) NSNumber * inventoryObjectID;
@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * retired;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSDate * purchaseDate;
@property (nonatomic, retain) NSNumber * purchasePrice;
@property (nonatomic, retain) NSSet *action;
@end

@interface InventoryItem (CoreDataGeneratedAccessors)

- (void)addActionObject:(InventoryAction *)value;
- (void)removeActionObject:(InventoryAction *)value;
- (void)addAction:(NSSet *)values;
- (void)removeAction:(NSSet *)values;

@end
