//
//  iris_ActionDetailsViewController.m
//  Iris
//
//  Created by Benjamin Myers on 6/11/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

// Controllers Import
#import "iris_ActionDetailsViewController.h"

// Models Import
#import "InventoryDataHandler.h"

@interface iris_ActionDetailsViewController ()
{
	InventoryDataHandler *dataHandler;
}

@end

@implementation iris_ActionDetailsViewController

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
	
	dataHandler = [[InventoryDataHandler alloc] init];
	_tfActionLongValue.text = _action.actionLongValue;
	_tfAuthorizedBy.text = _action.userAuthorizingAction;
	_tfPerformedAction.text = _action.userPerformingAction;
	_tfUserExtension.text = [NSString stringWithFormat:@"%@", _action.userPerformingActionExt];
	_tvNotes.text = _action.notes;
	
	_editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editDetails)];
	_saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDetails)];
	
	self.navigationItem.rightBarButtonItem = _editButton;
}

- (void)editDetails
{
	self.navigationItem.rightBarButtonItem = _saveButton;
	_tfActionDate.borderStyle = UITextBorderStyleRoundedRect;
	_tfActionLongValue.borderStyle = UITextBorderStyleRoundedRect;
	_tfAuthorizedBy.borderStyle = UITextBorderStyleRoundedRect;
	_tfPerformedAction.borderStyle = UITextBorderStyleRoundedRect;
	_tfUserExtension.borderStyle = UITextBorderStyleRoundedRect;
	_tfActionDate.enabled = TRUE;
	_tfActionLongValue.enabled = TRUE;
	_tfAuthorizedBy.enabled = TRUE;
	_tfPerformedAction.enabled = TRUE;
	_tfUserExtension.enabled = TRUE;
	_tvNotes.editable = TRUE;
}

- (void)saveDetails
{
	self.navigationItem.rightBarButtonItem = _editButton;
	_tfActionDate.borderStyle = UITextBorderStyleNone;
	_tfActionLongValue.borderStyle = UITextBorderStyleNone;
	_tfAuthorizedBy.borderStyle = UITextBorderStyleNone;
	_tfPerformedAction.borderStyle = UITextBorderStyleNone;
	_tfUserExtension.borderStyle = UITextBorderStyleNone;
	_tfActionDate.enabled = FALSE;
	_tfActionLongValue.enabled = FALSE;
	_tfAuthorizedBy.enabled = FALSE;
	_tfPerformedAction.enabled = FALSE;
	_tfUserExtension.enabled = FALSE;
	_tvNotes.editable = FALSE;
	int actionID;
	if ([_tfActionLongValue.text isEqualToString:@"Check In"])
	{
		actionID = 1;
	}
	else if ([_tfActionLongValue.text isEqualToString:@"Check Out"])
	{
		actionID = 2;
	}
	[dataHandler updateActionWithID:[_action.inventoryActionID intValue] andActionDate:[NSDate date] andNotes:_tvNotes.text andUserAuthorizingAction:_tfAuthorizedBy.text andUserPerformingAction:_tfPerformedAction.text andUserPerformingActionExt:[_tfUserExtension.text intValue] andInventoryObjectID:[_action.inventoryObjectID intValue] andUserActionID:actionID andActionLongValue:_tfActionLongValue.text];
}

- (IBAction)deleteAction:(id)sender
{
	_alert = [[UIAlertView alloc]initWithTitle:@"Delete Item" message:[NSString stringWithFormat:@"Are you sure that you want to delete this action? This process cannot be undone."] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
	[_alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
		_fetchRequest = [[NSFetchRequest alloc] init];
		_entity = [NSEntityDescription entityForName:@"InventoryAction" inManagedObjectContext:[self managedObjectContext]];
		_predicate = [NSPredicate predicateWithFormat:@"inventoryActionID == %@", _action.inventoryActionID];
		
		[_fetchRequest setEntity:_entity];
		[_fetchRequest setPredicate:_predicate];
		
		NSError *error;
		_fetchedResults = [[self managedObjectContext] executeFetchRequest:_fetchRequest error:&error];
		
		_objectToDelete = [_fetchedResults objectAtIndex:0];
		[dataHandler deleteInventoryActionWithInventoryID:[_currentItem.inventoryObjectID intValue] andActionId:[_action.inventoryActionID intValue]];
		[[self managedObjectContext] deleteObject:_objectToDelete];
		[self.managedObjectContext save:nil];
			
		[self performSegueWithIdentifier:@"segueFromActionDeleteToInventory" sender:self];
    }
}
@end
