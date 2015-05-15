//
//  BaseCell.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

@import UIKit;

@interface RSSAbstractCell : UITableViewCell

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath;
-(void)showDisplay;
-(void)hideDisplay;

@end