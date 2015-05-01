//
//  UITableViewController+SeparatorZeroInset.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 01.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "UITableViewController+SeparatorZeroInset.h"

@implementation UITableViewController (SeparatorZeroInset)

/*
 *Используется для того чтобы убрать отступ у сепаратора слева iOS 8
 */

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end