//
//  RssItem.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSLentaItem.h"
#import "RSSEnclosure.h"

@implementation RSSLentaItem

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapKeyPath:@"category.text" toProperty:@"category"];
        [mapping mapKeyPath:@"link.text" toProperty:@"link"];
        [mapping mapKeyPath:@"title.text" toProperty:@"title"];
        [mapping mapKeyPath:@"description.text" toProperty:@"sDescription"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE,dd LLL y HH:mm:ss Z"];
        [mapping mapKeyPath:@"pubDate.text" toProperty:@"pubDate" withDateFormatter:dateFormatter];
        
        [mapping mapKeyPath:@"source" toProperty:@"source" withValueBlock:^(NSString *key, id value) {
            return @"lenta.ru";
        }];
        
        [mapping mapKeyPath:@"enclosure" toProperty:@"enclosure" withValueBlock:^(NSString *key, NSDictionary *value) {
            return [EKMapper objectFromExternalRepresentation:value
                                                  withMapping:[RSSEnclosure objectMapping]];
        }];
        
    }];
}

@end