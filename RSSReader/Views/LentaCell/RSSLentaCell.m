//
//  RSSLentaCell.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 07.05.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSAbstractCell_Private.h"
#import "RSSLentaCell.h"
#import "AFHTTPRequestOperation.h"

#import "RSSLentaItem.h"
#import "RSSEnclosure.h"

#import "UIImageView+RSSLoadImage.h"

@interface RSSLentaCell()
@property (strong, nonatomic) AFHTTPRequestOperation *requestOperation;
@property (strong, nonatomic) UIImageView *viewImage;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;


@end

@implementation RSSLentaCell


#pragma mark - override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeAndAddSubviewViewImage];
        [self makeAndAddSubviewActivityIndicator];
    }
    return self;
}

-(void)makeAndAddSubviewViewImage {
    self.viewImage                  = [UIImageView newAutoLayoutView];
    self.viewImage.backgroundColor  = [UIColor lightGrayColor];
    self.viewImage.contentMode      = UIViewContentModeScaleAspectFill;
    self.viewImage.clipsToBounds    = YES;
    [self.contentView insertSubview:self.viewImage atIndex:0];
}

-(void)makeAndAddSubviewActivityIndicator {
    self.indicator = [UIActivityIndicatorView newAutoLayoutView];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicator setColor:[UIColor blackColor]];
    [self.indicator setHidesWhenStopped:YES];
    [self.contentView addSubview:self.indicator];
}

//Настройка констрейнтов
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self addConstraintsForTitileLabel];
        [self addConstraintsForViewImage];
        [self addConstraintsForSourceLabel];
        [self addConstraintsForActivityIndicator];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self.viewImage setImage:nil];
}

-(void)showDisplay {
    if([self.requestOperation isPaused])
        [self.requestOperation resume];
}

-(void)hideDisplay {
    if([self.requestOperation isExecuting])
        [self.requestOperation pause];
}


-(void)setItem:(RSSLentaItem *)item andIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(item);
    [self.titleLabel setText:item.title];
    
    if(item.enclosure.url)
        [self setImageWithNSURL:item.enclosure.url];
    
    [self setCurrentIndexPath:indexPath];
    [self.sourceLabel setText:[item source]];
}

#pragma mark - setting constraints

-(void)addConstraintsForTitileLabel {
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInsets];
}

-(void)addConstraintsForViewImage {
    //Выставляем высоту картинки с меньшим приоритетом
    //Иначе сыпятся варнинги
    [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
        [self.viewImage autoSetDimension:ALDimensionHeight toSize:250. relation:NSLayoutRelationGreaterThanOrEqual];
    }];
    
    [self.viewImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kHorizontalInsets];
    [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInsets];
    [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInsets];
    [self.viewImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalInsets];
}

-(void)addConstraintsForSourceLabel {
    //тянем source label по ширине ячейки
    [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInsets];
    [self.sourceLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInsets];
    //Ставим source label по центру картинки
    [self.sourceLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewImage];
}

-(void)addConstraintsForActivityIndicator {
    [self.indicator autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.viewImage];
    [self.indicator autoAlignAxis:ALAxisVertical toSameAxisOfView:self.viewImage];
}

#pragma mark - private method

-(void)setImageWithNSURL:(NSURL *)URL {
    NSParameterAssert(URL);
    
    [self.indicator startAnimating];
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:URL]];
    self.requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    
    [self.requestOperation start];
}

@end