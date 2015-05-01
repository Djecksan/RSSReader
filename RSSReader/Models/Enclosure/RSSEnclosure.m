//
//  RSSEnclosure.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSEnclosure.h"

@implementation RSSEnclosure

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromArray:@[@"length", @"text", @"type"]];
        
        [mapping mapKeyPath:@"url" toProperty:@"url" withValueBlock:^(NSString *key, id value) {
            return [NSURL URLWithString:value];
        }];
         
    }];
    
}

@end