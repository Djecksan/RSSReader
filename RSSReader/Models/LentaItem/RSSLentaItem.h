//
//  RssItem.h
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//
#import "EasyMapping.h"

@class RSSEnclosure;
@interface RSSLentaItem : NSObject<EKMappingProtocol>

@property (nonatomic, copy)   NSString *link;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *category;
@property (nonatomic, copy)   NSString *sDescription;
@property (nonatomic, copy)   NSString *source;
@property (nonatomic, copy)   NSDate   *pubDate;
@property (nonatomic, strong) RSSEnclosure *enclosure;

@end