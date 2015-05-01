//
//  RSSItemCell.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSItemCell.h"

//models
#import "RSSLentaItem.h"
#import "RSSGazetaItem.h"
#import "RSSEnclosure.h"

#import "AFHTTPRequestOperation.h"

@interface RSSItemCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *viewImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;
@property (nonatomic) NSIndexPath *currentIndexPath;
@end

@implementation RSSItemCell

#pragma mark - publick method

+(CGFloat)heightWithItem:(id)item {
    NSString *title = [item title];
    CGFloat imageHeight = 0;
    
    CGSize displaySize = [UIScreen mainScreen].bounds.size;
    CGSize sizeText = [title boundingRectWithSize:CGSizeMake(displaySize.width - 16, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:16.] }
                                      context:nil].size;
    
    if([item isKindOfClass:[RSSLentaItem class]] && [item valueForKeyPath:@"enclosure.url"]) {
        imageHeight = 250.;
    }
    
    return 8 + sizeText.height + imageHeight + 16;
}

-(void)setItem:(id)item andIndexPath:(NSIndexPath *)indexPath {
    if([item isKindOfClass:[RSSLentaItem class]]) {
        [self setLentaItem:item];
    } else if([item isKindOfClass:[RSSGazetaItem class]]) {
        [self setGazetaItem:item];
    }
    
    [self setCurrentIndexPath:indexPath];
    [self.sourceLabel setText:[item source]];
}

-(void)showDisplay {
    if(_requestOperation && [_requestOperation isPaused])
        [_requestOperation resume];
}

-(void)hideDisplay {
    if(_requestOperation && [_requestOperation isExecuting])
        [_requestOperation pause];
}

#pragma mark - private method

-(void)setLentaItem:(RSSLentaItem *)item {
    [_title setText:item.title];
    
    if(item.enclosure.url)
        [self setImageWithNSURL:item.enclosure.url];
}

-(void)setGazetaItem:(RSSGazetaItem *)item {
    [_title setText:item.title];
}

-(void)setImageWithNSURL:(NSURL *)URL {
    NSParameterAssert(URL);
    
    [_indicator startAnimating];
    __weak typeof(self) weakSelf = self;
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:URL]];
    
    _requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if(weakSelf.tag == weakSelf.currentIndexPath.item) {
            weakSelf.viewImage.image = responseObject;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            
            [weakSelf.layer addAnimation:transition forKey:nil];
        }
        
        [weakSelf.indicator stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.indicator stopAnimating];
        NSLog(@"Image error: %@", error);
    }];
    
    [_requestOperation start];
}

-(void)prepareForReuse {
    [_viewImage setImage:nil];
}

@end
