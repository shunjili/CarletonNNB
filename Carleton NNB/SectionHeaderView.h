//
//  SectionHeaderView.h
//  Carleton NNB
//
//  Created by Shunji Li on 12-10-22.
//  Copyright (c) 2012年 Shunji Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;


@interface SectionHeaderView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
@end

@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end
