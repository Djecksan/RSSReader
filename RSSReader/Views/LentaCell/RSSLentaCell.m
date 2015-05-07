//
//  RSSLentaCell.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSLentaCell.h"
#import "AFHTTPRequestOperation.h"

#import "RSSLentaItem.h"
#import "RSSEnclosure.h"

@interface RSSLentaCell()
@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;
@property (weak, nonatomic) IBOutlet UIImageView *viewImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic) BOOL didSetupConstraints;
@end

@implementation RSSLentaCell

#pragma mark - ovveride methods

-(void)setItem:(RSSLentaItem *)item andIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    [self.title setText:item.title];
    
    if(item.enclosure.url)
        [self setImageWithNSURL:item.enclosure.url];
    
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
