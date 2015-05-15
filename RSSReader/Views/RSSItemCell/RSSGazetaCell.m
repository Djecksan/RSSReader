//
//  RSSItemCell.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//
#import "RSSAbstractCell_Private.h"

#import "RSSGazetaCell.h"
#import "RSSGazetaItem.h"

@implementation RSSGazetaCell

#pragma mark - override

-(void)setItem:(RSSGazetaItem *)item andIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    [self.titleLabel setText:item.title];
    [self.sourceLabel setText:[item source]];
}

//Настройка констрейнтов
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {        
        [self addConstraintsForTitileLabel];
        [self addConstraintsForSourceLabel];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - setting constraints

-(void)addConstraintsForTitileLabel {
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalInsets];
}

-(void)addConstraintsForSourceLabel {
    [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInsets];
    [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInsets];
    [self.sourceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.sourceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
}

@end