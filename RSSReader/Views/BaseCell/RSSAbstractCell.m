//
//  BaseCell.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSAbstractCell.h"

@interface RSSAbstractCell()

@end

@implementation RSSAbstractCell

#pragma mark -  optional override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.titleLabel = [UILabel newAutoLayoutView];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.sourceLabel = [UILabel newAutoLayoutView];
        [self.sourceLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.sourceLabel setNumberOfLines:1];
        [self.sourceLabel setTextAlignment:NSTextAlignmentCenter];
        [self.sourceLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
        [self.sourceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:50.]];
        self.sourceLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.sourceLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
}

-(void)showDisplay { /*optional */ }

-(void)hideDisplay { /*optional */ }

#pragma mark -  must override

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath {
    SUBCLASS_MUST_OVERRIDE;
}



@end