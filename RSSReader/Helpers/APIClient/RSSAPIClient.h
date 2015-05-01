//
//  RSSAPIClient.h
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

@import UIKit;

typedef void(^RSSAPIClientSuccess)(id result);
typedef void(^RSSAPIClientFailure)(id error);

@interface RSSAPIClient : NSObject

- (void)enqueueRequestWithUrl:(NSURLRequest *)request
                      success:(RSSAPIClientSuccess)success
                      failure:(RSSAPIClientFailure)failure;

-(NSMutableURLRequest *)requestWithURLString:(NSString *)url andParameters:(NSDictionary *)parameters andMethod:(NSString *)method;

@end