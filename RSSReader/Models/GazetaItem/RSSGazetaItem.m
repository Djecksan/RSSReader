//
//  RSSGazetaItem.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSGazetaItem.h"

@implementation RSSGazetaItem

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapKeyPath:@"title.text" toProperty:@"title"];
        [mapping mapKeyPath:@"description.text" toProperty:@"sDescription"];
        
        [mapping mapKeyPath:@"source" toProperty:@"source" withValueBlock:^(NSString *key, id value) {
            return @"gazeta.ru";
        }];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE,dd LLL y HH:mm:ss Z"];
        [mapping mapKeyPath:@"pubDate.text" toProperty:@"pubDate" withDateFormatter:dateFormatter];
        
    }];
}


@end
