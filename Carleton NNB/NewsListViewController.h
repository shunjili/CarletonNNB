//
//  NewsListViewController.h
//  Carleton NNB
//
//  Created by Shunji Li on 12-10-21.
//  Copyright (c) 2012年 Shunji Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFeedItem.h"

@interface NewsListViewController : UITableViewController<NSXMLParserDelegate>{
    int itemCount;
}

@property (nonatomic, strong) NewFeedItem *currentItem; //items to hold temporary news
@property (nonatomic, strong) NSMutableString *currentString; //String to hold current value
@property (nonatomic, strong) NSMutableArray *currentSection;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSMutableArray *parsingArray;
@property (nonatomic, strong) NSString *previousCategory;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@end
