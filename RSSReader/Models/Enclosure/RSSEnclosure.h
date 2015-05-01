//
//  RSSEnclosure.h
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "EasyMapping.h"

@interface RSSEnclosure : NSObject<EKMappingProtocol>
@property (nonatomic, copy)   NSNumber *length;
@property (nonatomic, copy)   NSString *text;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSURL    *url;
@end