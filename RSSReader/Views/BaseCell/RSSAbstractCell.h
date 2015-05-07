//
//  BaseCell.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

@import UIKit;
#import "MustOverride.h"

@interface RSSAbstractCell : UITableViewCell
@property (nonatomic) NSIndexPath *currentIndexPath;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath;
-(void)showDisplay;
-(void)hideDisplay;

@end