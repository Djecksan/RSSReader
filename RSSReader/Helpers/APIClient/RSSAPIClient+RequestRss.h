//
//  RSSAPIClient+RequestRss.h
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSAPIClient.h"

@interface RSSAPIClient (RequestRss)

-(void)requestRss:(RSSAPIClientSuccess)success failure:(RSSAPIClientFailure)failure;

@end