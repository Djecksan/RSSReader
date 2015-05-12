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
@property (strong, nonatomic) IBOutlet UIImageView *viewImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end

@implementation RSSLentaCell


#pragma mark - override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewImage                  = [UIImageView newAutoLayoutView];
        self.viewImage.backgroundColor  = [UIColor lightGrayColor];
        self.viewImage.contentMode      = UIViewContentModeScaleAspectFill;
        self.viewImage.clipsToBounds    = YES;
        [self.contentView insertSubview:self.viewImage atIndex:0];
        
        self.indicator = [UIActivityIndicatorView newAutoLayoutView];
        [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.indicator setColor:[UIColor blackColor]];
        [self.indicator setHidesWhenStopped:YES];
        [self.contentView addSubview:self.indicator];
    }
    
    return self;
}

//Настройка констрейнтов
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.];
        
        //Выставляем высоту картинки с меньшим приоритетом
        //Иначе сыпятся варнинги
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.viewImage autoSetDimension:ALDimensionHeight toSize:250. relation:NSLayoutRelationGreaterThanOrEqual];
        }];
        
        [self.viewImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:8.];
        
        [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.];
        [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.];
        [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:4.];
        
        //тянем source label по ширине ячейки
        [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:8.];
        [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:8.];
        //Ставим source label по центру картинки
        [self.sourceLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewImage];
        
        [self.indicator autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewImage];
        [self.indicator autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewImage];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [_viewImage setImage:nil];
}

-(void)showDisplay {
    if(_requestOperation && [_requestOperation isPaused])
        [_requestOperation resume];
}

-(void)hideDisplay {
    if(_requestOperation && [_requestOperation isExecuting])
        [_requestOperation pause];
}


-(void)setItem:(RSSLentaItem *)item andIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    [self.titleLabel setText:item.title];
    
    if(item.enclosure.url)
        [self setImageWithNSURL:item.enclosure.url];
    
    [self setCurrentIndexPath:indexPath];
    [self.sourceLabel setText:[item source]];
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

@end
