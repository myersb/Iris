//
//  iris_ItemDetailsViewController.m
//  Iris
//
//  Created by Benjamin Myers on 4/29/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Import Controllers
#import "iris_ItemDetailsViewController.h"
#import "iris_InventoryActionsTableViewController.h"

// Import Data
#import "InventoryItem.h"
#import "InventoryAction.h"

// Import Models
#import "InventoryDataHandler.h"

@interface iris_ItemDetailsViewController ()
{
	InventoryDataHandler *dataHandler;
}
@end

@implementation iris_ItemDetailsViewController

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
	
	id delegate = [[UIApplication sharedApplication]delegate];
	self.managedObjectContext = [delegate managedObjectContext];
	
	[self displayInventoryDetails];
	
	dataHandler = [[InventoryDataHandler alloc] init];
	
	_editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editDetails)];
	_saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDetails)];
	
	self.navigationItem.rightBarButtonItem = _editButton;
	
	_tfItemDescription.enabled = FALSE;
	_tfAssetTag.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayInventoryDetails
{
	// Set information for labels and text boxes
	_lblItemDescription.text = _currentInventoryItem.objectDescription;
	_lblAssetTag.text = [NSString stringWithFormat:@"Asset ID: %@", _currentInventoryItem.assetID];
	_lblPurchasePrice.text = [NSString stringWithFormat:@"%@", _currentInventoryItem.purchasePrice];
	_lblQuantity.text = [NSString stringWithFormat:@"%@", _currentInventoryItem.quantity];
	_lblSerialNumber.text = [NSString stringWithFormat:@"%@", _currentInventoryItem.serialNumber];
	
	_tfItemDescription.text = _currentInventoryItem.objectDescription;
	_tfAssetTag.text = _currentInventoryItem.assetID;
	_tfQuantity.text = [NSString stringWithFormat:@"%@", _currentInventoryItem.quantity];
	_tfPurchasePrice.text = [NSString stringWithFormat:@"%@", _currentInventoryItem.purchasePrice];
	
	// Get current status of the item
	NSSet *actions = _currentInventoryItem.action;
	NSSortDescriptor *actionsSort = [NSSortDescriptor sortDescriptorWithKey:@"actionID" ascending:YES];
	_entity = [NSEntityDescription entityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
	_sortedActions = [actions sortedArrayUsingDescriptors:[NSArray arrayWithObject:actionsSort]];
	InventoryAction *action = [[InventoryAction alloc] initWithEntity:_entity insertIntoManagedObjectContext:[self managedObjectContext]];
	
	// Display current status of the item
	if ([_sortedActions count] > 0) {
		action = [_sortedActions objectAtIndex:0];
		if ([action.actionLongValue isEqualToString:@"Check Out"]) {
			_lblItemStatus.text = @"Current Status: Out";
		} else {
			_lblItemStatus.text = @"Current Status: Available";
		}
	} else {
		_lblItemStatus.text = @"Current Status: Available";
	}
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToActionHistory"]) {
		iris_InventoryActionsTableViewController *iatvc = [segue destinationViewController];
		iatvc.currentItem = _currentInventoryItem;
	}
}

- (void)editDetails
{
	self.navigationItem.rightBarButtonItem = _saveButton;
	
	_tfItemDescription.enabled = TRUE;
	_tfAssetTag.enabled = TRUE;
	_tfQuantity.enabled = TRUE;
	_tfPurchasePrice.enabled = TRUE;
	_tfItemDescription.hidden= FALSE;
	_tfAssetTag.hidden = FALSE;
	_tfQuantity.hidden = FALSE;
	_tfPurchasePrice.hidden = FALSE;
	_changeDateButton.hidden = FALSE;
	_deleteButton.hidden = FALSE;
}

- (void)saveDetails
{
	self.navigationItem.rightBarButtonItem = _editButton;
	
	_tfItemDescription.enabled = FALSE;
	_tfAssetTag.enabled = FALSE;
	_tfQuantity.enabled = FALSE;
	_tfPurchasePrice.enabled = FALSE;
	_tfItemDescription.hidden= TRUE;
	_tfAssetTag.hidden = TRUE;
	_tfQuantity.hidden = TRUE;
	_tfPurchasePrice.hidden = TRUE;
	_changeDateButton.hidden = TRUE;
	_deleteButton.hidden = TRUE;
	
	_lblItemDescription.text = _tfItemDescription.text;
	_lblAssetTag.text = [NSString stringWithFormat:@"Asset ID: %@", _tfAssetTag.text];
	
	[dataHandler updateInventoryObjectWithID:[_currentInventoryItem.inventoryObjectID intValue]
								  andAssetID:_tfAssetTag.text
								 andQuantity:[_tfQuantity.text intValue]
							 andSerialNumber:_currentInventoryItem.serialNumber
							  andDescription:_tfItemDescription.text
							  andAllowAction:TRUE andRetired:FALSE
							 andPurchaseDate:[NSDate date]
							andPurchasePrice:[_tfPurchasePrice.text floatValue]];
}

- (IBAction)deleteInventoryItem:(id)sender
{
	
}

- (IBAction)selectDate:(id)sender
{
	_datePicker.hidden = FALSE;
}

- (void)changeDate
{
	NSDate *myDate = _datePicker.date;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
	NSString *prettyDate = [dateFormat stringFromDate:myDate];
	NSLog(@"%@", prettyDate);
}
@end
