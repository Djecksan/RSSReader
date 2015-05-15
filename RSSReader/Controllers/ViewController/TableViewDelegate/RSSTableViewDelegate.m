//
//  RSSTableViewDelegate.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 12.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSTableViewDelegate.h"
//cells
#import "RSSGazetaCell.h"
#import "RSSLentaCell.h"
//models
#import "RSSLentaItem.h"
#import "RSSGazetaCell.h"

NSString * const kLentaCellIdentifier  = @"RSSLentaCellIdentifier";
NSString * const kGazetaCellIdentifier = @"RSSGazetaCellIdentifier";


@interface RSSTableViewDelegate()
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@end

@implementation RSSTableViewDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.offscreenCells = [NSMutableDictionary dictionary];
        self.displayItems   = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public method

-(void)setDataSource:(NSArray *)dataSource {
    NSParameterAssert(dataSource);
    [self.displayItems setArray:dataSource];
}

#pragma mark - UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayItems count];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(RSSAbstractCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell showDisplay];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(RSSAbstractCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hideDisplay];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_didSelectCell)
        _didSelectCell(_displayItems[indexPath.item]);
}

-(RSSAbstractCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSAbstractCell *cell = [self fabricCellWithIndexPath:indexPath withTableView:tableView];
    [cell setItem:_displayItems[indexPath.item] andIndexPath:indexPath];
    [cell setTag:indexPath.item];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class classCell = [self classCellWithSource:_displayItems[indexPath.item]];

    NSString *reuseIdentifier = classCell == [RSSLentaCell class] ? kLentaCellIdentifier : kGazetaCellIdentifier;
    
    RSSAbstractCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    
    if (!cell) {
        cell = [[classCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    [cell setItem:_displayItems[indexPath.item] andIndexPath:indexPath];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    
    return height;
}

-(Class)classCellWithSource:(id)source {
    if ([source class] == [RSSLentaItem class]) {
        return [RSSLentaCell class];
    } else {
        return [RSSGazetaCell class];
    }
}

-(RSSAbstractCell *)fabricCellWithIndexPath:(NSIndexPath*)indexPath withTableView:(UITableView *)tableView  {
    
    if([_displayItems[indexPath.item] isKindOfClass:[RSSLentaItem class]]) {
        return [tableView dequeueReusableCellWithIdentifier:kLentaCellIdentifier forIndexPath:indexPath];
    } else {
        return [tableView dequeueReusableCellWithIdentifier:kGazetaCellIdentifier forIndexPath:indexPath];
    }
    
}


@end