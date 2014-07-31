//
//  iris_NewInventoryViewController.m
//  Iris
//
//  Created by Benjamin Myers on 6/4/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Controllers Import
#import "iris_NewInventoryViewController.h"

// Models Import
#import "InventoryDataHandler.h"

@interface iris_NewInventoryViewController ()
{
	InventoryDataHandler *dataHandler;
}
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
	
	dataHandler = [[InventoryDataHandler alloc] init];
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.scrollView addGestureRecognizer:gestureRecognizer];
    [_scrollView setContentOffset:CGPointMake(0,66) animated:YES];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_activeField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField.center.y > 280) {
		[_scrollView setContentOffset:CGPointMake(0,textField.center.y-276) animated:YES];
	}
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

- (void) hideKeyboard {
	[_activeField resignFirstResponder];
	[_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (IBAction)showDatePicker:(id)sender
{
	_datePickerView.hidden = FALSE;
	[_activeField resignFirstResponder];
}

- (IBAction)addItem:(id)sender
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
	^{
		[dataHandler insertInventoryObjectWithAssetID:_tfAssetTag.text
										  andQuantity:[_tfQuantity.text intValue]
									  andSerialNumber:_tfSerialNumber.text
									   andDescription:_tfDescription.text
									   andAllowAction:true andRetired:false
									  andPurchaseDate:_selectedDate
									 andPurchasePrice:[_tfPurchasePrice.text floatValue]];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self performSegueWithIdentifier:@"segueFromNewToItemInventory" sender:self];
		});
	});
				
}

- (IBAction)saveDate:(id)sender
{
	_datePickerView.hidden = TRUE;
	_selectedDate = _datePicker.date;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMM dd, YYYY"];
	NSString *prettyDate = [dateFormat stringFromDate:_selectedDate];
	_lblPurchaseDate.text = prettyDate;
}

- (IBAction)setActiveTextField:(id)sender
{
	_activeField = sender;
}
@end
