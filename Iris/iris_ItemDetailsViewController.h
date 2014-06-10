//
//  iris_ItemDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 4/29/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"

@interface iris_ItemDetailsViewController : UIViewController

// CoreData Properties
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSPredicate *predicate;

// UI Properties
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic, strong) IBOutlet UILabel *lblItemDescription;
@property (nonatomic, strong) IBOutlet UILabel *lblAssetTag;
@property (nonatomic, strong) IBOutlet UILabel *lblItemStatus;
@property (nonatomic, weak) IBOutlet UIPickerView *actionPicker;
@property (nonatomic, weak) IBOutlet UITextField *tfItemDescription;
@property (nonatomic, weak) IBOutlet UITextField *tfAssetTag;
@property (nonatomic, weak) IBOutlet UITextField *tfQuantity;
@property (nonatomic, weak) IBOutlet UITextField *tfPurchasePrice;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

// Variable Properties
@property (strong, nonatomic) InventoryItem *currentInventoryItem;

// Actions
@end
