//
//  iris_ActionDetailsViewController.m
//  Iris
//
//  Created by Benjamin Myers on 6/11/14.
//  Copyright (c) 2014 claytonhomes.com. All rights reserved.
//

#import "iris_ActionDetailsViewController.h"

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
}

@end
