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

-(void)viewDidLoad
{
	[super viewDidLoad];
    // Do any additional setup after loading the view.
	_tfActionLongValue.text = _action.actionLongValue;
	_tfAuthorizedBy.text = _action.userAuthorizingAction;
	_tfPerformedAction.text = _action.userPerformingAction;
	_tfUserExtension.text = [NSString stringWithFormat:@"%@", _action.userPerformingActionExt];
	_tvNotes.text = _action.notes;
}

@end
