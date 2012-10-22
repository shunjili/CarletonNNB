//
//  NewDetailViewController.h
//  Carleton NNB
//
//  Created by Shunji Li on 12-10-21.
//  Copyright (c) 2012年 Shunji Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedItem.h"

@interface NewDetailViewController : UIViewController
@property (nonatomic, strong) NewFeedItem *item;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UITextView *aTextView;
@end
