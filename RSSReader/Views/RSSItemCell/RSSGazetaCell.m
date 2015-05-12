//
//  RSSItemCell.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

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
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:4.];
        
        [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.];
        [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.];
        [self.sourceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.sourceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

@end