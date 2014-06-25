//
//  iris_MenuViewController.h
//  Iris
//
//  Created by Benjamin Myers on 5/21/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_MenuViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

// UI Properties
@property (nonatomic, strong) UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Variable Properties
@property (strong, nonatomic) UITextField *activeField;

// Actions
- (IBAction)login:(id)sender;

@end
