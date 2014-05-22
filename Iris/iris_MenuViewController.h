//
//  iris_MenuViewController.h
//  Iris
//
//  Created by Benjamin Myers on 5/21/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_MenuViewController : UIViewController

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSSortDescriptor *sort;
@property (nonatomic, strong) NSArray *sortDescriptors;

// Variable Properties
@property (nonatomic, strong) NSArray *fetchedObjects;

@end
