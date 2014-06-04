//
//  iris_NewInventoryViewController.h
//  Iris
//
//  Created by Benjamin Myers on 6/4/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_NewInventoryViewController : UIViewController

// UI Properties
@property (weak, nonatomic) IBOutlet UITextField *lblDescription;
@property (weak, nonatomic) IBOutlet UITextField *lblAssetTag;
@property (weak, nonatomic) IBOutlet UITextField *lblQuantity;
@property (weak, nonatomic) IBOutlet UITextField *lblSerialNumber;
@property (weak, nonatomic) IBOutlet UITextField *lblPurchaseDate;
@property (weak, nonatomic) IBOutlet UITextField *lblPurchasePrice;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

// Actions
- (IBAction)showDatePicker:(id)sender;
@end
