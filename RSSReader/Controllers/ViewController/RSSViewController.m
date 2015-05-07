//
//  ViewController.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSViewController.h"
#import "RSSDetailController.h"

#import "RSSAPIClient.h"
#import "RSSAPIClient+RequestRss.h"

#import "RSSGazetaCell.h"
#import "RSSLentaCell.h"

#import "UITableViewController+SeparatorZeroInset.h"

#import "RSSLentaItem.h"
#import "RSSGazetaItem.h"

static NSString *kLentaCellIdentifier  = @"RSSLentaCellIdentifier";
static NSString *kGazetaCellIdentifier = @"RSSGazetaCellIdentifier";

@interface RSSViewController ()
@property (strong, nonatomic) RSSAPIClient   *apiClient;
@property (strong, nonatomic) NSMutableArray *displayItems;
@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayItems = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    self.apiClient = [[RSSAPIClient alloc] init];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 10.0;
    
    [self.apiClient requestRss:^(NSArray *result) {
        NSParameterAssert(result);
        
        [self.displayItems setArray:result];
        [self.tableView reloadData];
    } failure:^(NSArray *errors) {
        //При необходимости сообщить об ошибках или залогировать их
        NSLog(@"Ошибки загрузки данных - %@", errors);
    }];
}

#pragma mark - UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_displayItems count];
}

#pragma mark - UITableView delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(RSSAbstractCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    [cell showDisplay];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(RSSAbstractCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hideDisplay];
}

-(RSSAbstractCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSAbstractCell *cell = [self fabricCellWithIndexPath:indexPath];
    [cell setItem:_displayItems[indexPath.item] andIndexPath:indexPath];
    [cell setTag:indexPath.item];

    return cell;
}

-(RSSAbstractCell *)fabricCellWithIndexPath:(NSIndexPath*)indexPath  {
    
    if([_displayItems[indexPath.item] isKindOfClass:[RSSLentaItem class]]) {
        return [self.tableView dequeueReusableCellWithIdentifier:kLentaCellIdentifier forIndexPath:indexPath];
    } else {
        return [self.tableView dequeueReusableCellWithIdentifier:kGazetaCellIdentifier forIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"RSSDetailController"]) {
         UITableViewCell *cell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
         
         RSSDetailController *detailController = [segue destinationViewController];
         [detailController setRssItem:_displayItems[indexPath.item]];
     }
}

@end