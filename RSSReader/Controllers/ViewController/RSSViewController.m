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

#import "RSSTableViewDelegate.h"

@interface RSSViewController ()
@property (strong, nonatomic) RSSAPIClient   *apiClient;
@property (strong, nonatomic) NSMutableArray *displayItems;
@property (strong, nonatomic) RSSTableViewDelegate *tableDelegate;
@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayItems = [NSMutableArray array];
    
    self.tableDelegate = [[RSSTableViewDelegate alloc] init];
    [self.tableView setDelegate:self.tableDelegate];
    [self.tableView setDataSource:self.tableDelegate];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.apiClient = [[RSSAPIClient alloc] init];
    
    [self.tableView registerClass:[RSSGazetaCell class] forCellReuseIdentifier:kGazetaCellIdentifier];
    [self.tableView registerClass:[RSSLentaCell class] forCellReuseIdentifier:kLentaCellIdentifier];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    
    [self.apiClient requestRss:^(NSArray *result) {
        NSParameterAssert(result);
        [self.tableDelegate setDataSource:result];
        [self.tableView reloadData];
    } failure:^(NSArray *errors) {
        //При необходимости сообщить об ошибках или залогировать их
        NSLog(@"Ошибки загрузки данных - %@", errors);
    }];
}

//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     if([segue.identifier isEqualToString:@"RSSDetailController1"] || [segue.identifier isEqualToString:@"RSSDetailController2"]) {
//         UITableViewCell *cell = sender;
//         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//         
//         RSSDetailController *detailController = [segue destinationViewController];
//         [detailController setRssItem:_displayItems[indexPath.item]];
//     }
//}

@end