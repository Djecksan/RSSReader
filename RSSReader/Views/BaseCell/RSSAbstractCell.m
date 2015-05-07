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

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath {
    SUBCLASS_MUST_OVERRIDE;
}

-(void)showDisplay { /*optional */ }

-(void)hideDisplay { /*optional */ }

@end