//
//  iris_NewInventoryViewController.h
//  Iris
//
//  Created by Benjamin Myers on 6/4/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_NewInventoryViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

// UI Properties
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UITextField *tfAssetTag;
@property (weak, nonatomic) IBOutlet UITextField *tfQuantity;
@property (weak, nonatomic) IBOutlet UITextField *tfSerialNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfPurchaseDate;
@property (weak, nonatomic) IBOutlet UITextField *tfPurchasePrice;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblPurchaseDate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Variable Properties
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) UITextField *activeField;

// Actions
- (IBAction)showDatePicker:(id)sender;
- (IBAction)addItem:(id)sender;
- (IBAction)saveDate:(id)sender;
- (IBAction)setActiveTextField:(id)sender;
@end
