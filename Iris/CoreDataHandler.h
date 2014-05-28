//
//  CoreDataHandler.h
//  Iris
//
//  Created by Benjamin Myers on 5/28/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHandler : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;

// Actions
- (void)clearEntity:(NSString *)entityName withFetchRequest:(NSFetchRequest *)fetchRequest;

@end
