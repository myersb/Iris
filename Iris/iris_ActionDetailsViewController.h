//
//  iris_ActionDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 6/11/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryAction.h"
#import "InventoryItem.h"

@interface iris_ActionDetailsViewController : UIViewController <UIAlertViewDelegate>

// Core Data Properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSEntityDescription *entity;
@property (strong, nonatomic) NSPredicate *predicate;

// UI Properties
@property (nonatomic, weak) IBOutlet UITextField *tfActionDate;
@property (nonatomic, weak) IBOutlet UITextField *tfActionLongValue;
@property (nonatomic, weak) IBOutlet UITextField *tfAuthorizedBy;
@property (nonatomic, weak) IBOutlet UITextField *tfPerformedAction;
@property (nonatomic, weak) IBOutlet UITextField *tfUserExtension;
@property (nonatomic, weak) IBOutlet UITextView *tvNotes;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) UIAlertView *alert;

// Variable Properties
@property (nonatomic, strong) InventoryAction *action;
@property (nonatomic, strong) InventoryItem *currentItem;
@property (nonatomic, strong) NSArray *fetchedResults;
@property (nonatomic, strong) NSManagedObject *objectToDelete;

// Action Properties
- (IBAction)deleteAction:(id)sender;
@end
