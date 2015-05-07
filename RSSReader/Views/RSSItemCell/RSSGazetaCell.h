//
//  RSSItemCell.h
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSItemCell : UITableViewCell

+(CGFloat)heightWithItem:(id)item;

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath;
-(void)showDisplay;
-(void)hideDisplay;
@end
