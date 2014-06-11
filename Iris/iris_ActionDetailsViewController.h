//
//  iris_ActionDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 6/11/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_ActionDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfActionDate;
@property (weak, nonatomic) IBOutlet UITextField *tfActionLongValue;
@property (weak, nonatomic) IBOutlet UITextField *tfAuthorizedBy;
@property (weak, nonatomic) IBOutlet UITextField *tfPerformedAction;
@property (weak, nonatomic) IBOutlet UITextField *tfUserExtension;
@property (weak, nonatomic) IBOutlet UITextView *tvNotes;

@end
