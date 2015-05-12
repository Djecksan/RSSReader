//
//  BaseCell.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

@import UIKit;

#import "MustOverride.h"
#import "PureLayout.h"

#define kLabelHorizontalInsets      8.0f
#define kLabelVerticalInsets        8.0f

@interface RSSAbstractCell : UITableViewCell
@property (nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;
@property (nonatomic) BOOL didSetupConstraints;

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath;
-(void)showDisplay;
-(void)hideDisplay;

@end