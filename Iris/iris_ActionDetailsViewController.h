//
//  iris_ActionDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 6/11/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryAction.h"

@interface iris_ActionDetailsViewController : UIViewController

// UI Properties
@property (nonatomic, weak) IBOutlet UITextField *tfActionDate;
@property (nonatomic, weak) IBOutlet UITextField *tfActionLongValue;
@property (nonatomic, weak) IBOutlet UITextField *tfAuthorizedBy;
@property (nonatomic, weak) IBOutlet UITextField *tfPerformedAction;
@property (nonatomic, weak) IBOutlet UITextField *tfUserExtension;
@property (nonatomic, weak) IBOutlet UITextView *tvNotes;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

// Variable Properties
@property (nonatomic, strong) InventoryAction *action;

@end
