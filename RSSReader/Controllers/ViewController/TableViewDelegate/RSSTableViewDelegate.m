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
    // This project has only one cell identifier, but if you are have more than one, this is the time
    // to figure out which reuse identifier should be used for the cell at this index path.
    NSString *reuseIdentifier = classCell == [RSSLentaCell class] ? kLentaCellIdentifier : kGazetaCellIdentifier;
    
    // Use the dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
    // it in the dictionary if one hasn't already been added for the reuse identifier.
    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
    // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
    
    RSSAbstractCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    
    if (!cell) {
        cell = [[classCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    [cell setItem:_displayItems[indexPath.item] andIndexPath:indexPath];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
    // if you are using a grouped table view style where cells have insets to the edges of the table view,
    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
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