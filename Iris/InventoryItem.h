//
//  InventoryItem.h
//  Iris
//
//  Created by Benjamin Myers on 5/20/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryAction;

@interface InventoryItem : NSManagedObject

@property (nonatomic, retain) NSNumber * assetID;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSString * objectDescription;
@property (nonatomic, retain) NSNumber * allowsActions;
@property (nonatomic, retain) NSNumber * retired;
@property (nonatomic, retain) InventoryAction *action;

@end
