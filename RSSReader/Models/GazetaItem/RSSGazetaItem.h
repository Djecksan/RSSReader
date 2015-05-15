//
//  RSSGazetaItem.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "EasyMapping.h"

@interface RSSGazetaItem : NSObject<EKMappingProtocol>
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *sDescription;
@property (nonatomic, copy)   NSDate   *pubDate;
@property (nonatomic, copy)   NSString *source;
@end