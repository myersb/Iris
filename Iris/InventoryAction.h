//
//  InventoryAction.h
//  Iris
//
//  Created by Benjamin Myers on 5/22/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryItem;

@interface InventoryAction : NSManagedObject

@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSNumber * actionID;
@property (nonatomic, retain) NSString * actionLongValue;
@property (nonatomic, retain) NSString * actionShortValue;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * userActionID;
@property (nonatomic, retain) NSString * userAuthorizingAction;
@property (nonatomic, retain) NSString * userPerformingAction;
@property (nonatomic, retain) NSNumber * userPerformingActionExt;
@property (nonatomic, retain) NSNumber * inventoryObjectID;
@property (nonatomic, retain) InventoryItem *object;

@end
