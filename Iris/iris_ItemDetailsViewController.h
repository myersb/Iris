//
//  iris_ItemDetailsViewController.h
//  Iris
//
//  Created by Benjamin Myers on 4/29/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iris_ItemDetailsViewController : UIViewController

// UI Properties
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UILabel *lblItemDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblAssetTag;
@property (strong, nonatomic) IBOutlet UILabel *lblItemStatus;
@property (weak, nonatomic) IBOutlet UIPickerView *actionPicker;

// Variable Properties


// Action
@end
