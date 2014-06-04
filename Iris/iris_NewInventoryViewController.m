//
//  iris_NewInventoryViewController.m
//  Iris
//
//  Created by Benjamin Myers on 6/4/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_NewInventoryViewController.h"

@interface iris_NewInventoryViewController ()

@end

@implementation iris_NewInventoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_datePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showDatePicker:(id)sender
{
	_datePicker.hidden = NO;
}
@end
