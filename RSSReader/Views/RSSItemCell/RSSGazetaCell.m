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

-(void)setItem:(RSSGazetaItem *)item andIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    [self.title setText:item.title];
    [self.sourceLabel setText:[item source]];
}


@end