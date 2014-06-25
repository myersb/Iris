//
//  iris_MenuViewController.m
//  Iris
//
//  Created by Benjamin Myers on 5/21/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_MenuViewController.h"
#import "Reachability.h"
#import "InventoryAction.h"
#import "InventoryItem.h"
#import "CoreDataHandler.h"
#import "InventoryDataHandler.h"
#import "MD5Hasher.h"
#import "UserLogin.h"

@interface iris_MenuViewController ()
{
    Reachability *internetReachable;
	InventoryDataHandler *dataHandler;
	CoreDataHandler *coreDataHandler;
	MD5Hasher *hashGenerator;
	UserLogin *userLoginInstance;
}
@end


@implementation iris_MenuViewController

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
	
	// Instantiations
    internetReachable = [[Reachability alloc] init];
	dataHandler = [[InventoryDataHandler alloc] init];
	hashGenerator = [[MD5Hasher alloc] init];
	userLoginInstance = [[UserLogin alloc] init];
	
	_tfUsername.delegate = self;
	_tfPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    [_scrollView setContentOffset:CGPointMake(0,textField.center.y-280) animated:YES];
}

// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
	
    if (nextResponder) {
        [_scrollView setContentOffset:CGPointMake(0,textField.center.y-80) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }
	
    return NO;
}


//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	
//    _scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y - 80);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)login:(id)sender
{
	
	
	// Run Methods
    [internetReachable checkConnection];
	
	// Check for internet availability
    if (internetReachable.isConnected) {
        NSLog(@"Now witness the firepower of this fully ARMED and OPERATIONAL battle station!");
		BOOL canSegue = [userLoginInstance validateLoginWithUsername:_tfUsername.text andPassword:_tfPassword.text];
		if (canSegue) {
			[self performSegueWithIdentifier:@"loginSegue" sender:self];
		} else {
			_alert = [[UIAlertView alloc]initWithTitle:@"Login Error" message:@"The username and/or password that was entered was incorrect. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[_alert show];
		}
    } else {
        NSLog(@"WHERE IS THE INTERWEBS?");
		_alert = [[UIAlertView alloc]initWithTitle:@"Connection Not Available" message:@"To login you must have a working internet connection. Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
		[_alert show];
    }
}
@end
