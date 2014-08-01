//
//  iris_ItemDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 4/29/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryItem.h"

@interface iris_ItemDetailsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

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
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchasePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNumber;
@property (nonatomic, weak) IBOutlet UIPickerView *actionPicker;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UITextField *tfItemDescription;
@property (nonatomic, weak) IBOutlet UITextField *tfAssetTag;
@property (nonatomic, weak) IBOutlet UITextField *tfQuantity;
@property (nonatomic, weak) IBOutlet UITextField *tfPurchasePrice;
@property (weak, nonatomic) IBOutlet UITextField *tfSerialNumber;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *changeDateButton;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Variable Properties
@property (nonatomic, strong) InventoryItem *currentInventoryItem;
@property (nonatomic, strong) NSArray *sortedActions;
@property (nonatomic, strong) NSDate *selectedDate;
@property (strong, nonatomic) UITextField *activeField;

// Actions
- (IBAction)deleteInventoryItem:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)selectDate:(id)sender;
@end
