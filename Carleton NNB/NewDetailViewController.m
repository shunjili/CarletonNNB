//
//  NewDetailViewController.m
//  Carleton NNB
//
//  Created by Shunji Li on 12-10-21.
//  Copyright (c) 2012年 Shunji Li. All rights reserved.
//

#import "NewDetailViewController.h"

@interface NewDetailViewController ()

@end

@implementation NewDetailViewController
@synthesize item= _item;
@synthesize descriptionLabel= _descriptionLabel;
@synthesize aTextView = _aTextView;
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
    _descriptionLabel.text = _item.category;
    NSMutableString *descriptionText = [NSMutableString stringWithString:_item.category];
    descriptionText = [descriptionText stringByAppendingString:@" :\n"];
    _aTextView.text = [descriptionText stringByAppendingString:_item.description];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
