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

- (void)hideKeyboard
{
	NSLog(@"BOOM");
	[_tfAssetTag resignFirstResponder];
	[_tfDescription resignFirstResponder];
	[_tfPurchasePrice resignFirstResponder];
	[_tfQuantity resignFirstResponder];
	[_tfSerialNumber resignFirstResponder];
}
@end
