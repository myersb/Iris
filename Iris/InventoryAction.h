//
//  InventoryAction.h
//  Iris
//
//  Created by Benjamin Myers on 5/20/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryItem;

@interface InventoryAction : NSManagedObject

@property (nonatomic, retain) NSNumber * actionID;
@property (nonatomic, retain) NSNumber * userPerformingActionExt;
@property (nonatomic, retain) NSNumber * userActionID;
@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * userPerformingAction;
@property (nonatomic, retain) NSString * userAuthorizingAction;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * actionShortValue;
@property (nonatomic, retain) NSString * actionLongValue;
@property (nonatomic, retain) InventoryItem *inventoryObjectID;

@end
