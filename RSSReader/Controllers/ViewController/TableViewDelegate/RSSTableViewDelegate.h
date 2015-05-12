//
//  RSSTableViewDelegate.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 12.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

@import UIKit;

typedef void(^RSSDidSelectCell)(id item);

extern NSString *const kLentaCellIdentifier;
extern NSString *const kGazetaCellIdentifier;

@interface RSSTableViewDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *displayItems;
@property (nonatomic, copy) RSSDidSelectCell didSelectCell;

-(void)setDataSource:(NSArray *)dataSource;

@end