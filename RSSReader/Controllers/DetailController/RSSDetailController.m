//
//  RSSDetailController.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 01.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "RSSLentaItem.h"

@interface RSSDetailController ()
@property (weak, nonatomic) IBOutlet UILabel                 *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView             *poster;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation RSSDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.navigationItem setTitle:[self.rssItem valueForKey:@"source"]];
    [_titleLabel setText:[self.rssItem valueForKey:@"title"]];
    [_descriptionLabel setText:[self.rssItem valueForKey:@"sDescription"]];
    
    if([self.rssItem isKindOfClass:[RSSLentaItem class]] && [self.rssItem valueForKeyPath:@"enclosure.url"]) {
        [self loadPosterWithURL:[self.rssItem valueForKeyPath:@"enclosure.url"]];
    }
}
-(void)loadPosterWithURL:(NSURL *)URL {
    NSParameterAssert(URL);
    
    [_activity startAnimating];
    [_poster setImageWithURLRequest:[NSURLRequest requestWithURL:URL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [_poster setImage:image];
        [_activity stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [_activity stopAnimating];
    }];
    
    [_poster setImageWithURL:URL placeholderImage:nil];
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [self heightWithText:_titleLabel.text andFont:_titleLabel.font];
        case 1:{
            if([self.rssItem isKindOfClass:[RSSLentaItem class]] && [self.rssItem valueForKeyPath:@"enclosure.url"]) {
                return 250.;
            } else
                return 0.;
        }  
        case 2:
            return [self heightWithText:_descriptionLabel.text andFont:_descriptionLabel.font];
        default:
            return 0.;
    }
}

#pragma mark - text calculate height

-(CGFloat)heightWithText:(NSString *)text andFont:(UIFont *)font {
    CGSize displaySize = [UIScreen mainScreen].bounds.size;
    
    CGSize sizeText = [text boundingRectWithSize:CGSizeMake(displaySize.width - 16, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize] }
                                          context:nil].size;
    //Высота текста + отступы
    return sizeText.height + 16;
}

@end