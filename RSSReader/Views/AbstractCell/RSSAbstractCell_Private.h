//
//  RSSAbstractCell_Private.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 15.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//
#import "RSSAbstractCell.h"

#import "MustOverride.h"
#import "PureLayout.h"

static const CGFloat kHorizontalInsets = 8.0f;
static const CGFloat kVerticalInsets = 4.0f;

@interface RSSAbstractCell()
@property (nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sourceLabel;
@property (nonatomic) BOOL didSetupConstraints;
@end
