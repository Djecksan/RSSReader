;//
//  RSSAPIClient+RequestRss.m
//  RSSReader
//
//  Created by e.Tulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSAPIClient+RequestRss.h"
#import "XMLReader.h"

//models
#import "RSSLentaItem.h"
#import "RSSGazetaItem.h"

@implementation RSSAPIClient (RequestRss)

-(void)requestRss:(RSSAPIClientSuccess)success failure:(RSSAPIClientFailure)failure {
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    //Массив для сбора новостей
    NSMutableArray *array = [NSMutableArray array];
    //Массив для сбора ошибок
    NSMutableArray *errors = [NSMutableArray array];
    
    //Создаю группу для обработки ряда задач
    dispatch_group_t group = dispatch_group_create();

    //Запрос новостей из ленты
    NSMutableURLRequest *lentaRequest = [self requestWithURLString:@"http://lenta.ru/rss" andParameters:nil andMethod:@"GET"];
    
    dispatch_group_enter(group);
    [self enqueueRequestWithUrl:lentaRequest success:^(id result) {

        //мапим модели данных
        NSArray *rss = [self rssArrayWithResponce:result classModel:[RSSLentaItem class]];
        [array addObjectsFromArray:rss];
        
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        [errors addObject:error];
        dispatch_group_leave(group);
    }];
    
    //Запрос новостей из газеты
    NSMutableURLRequest *gazetaRequest = [self requestWithURLString:@"http://www.gazeta.ru/export/rss/lenta.xml" andParameters:nil andMethod:@"GET"];
    
    //Подменяю userAgent для того чтобы ни редиректило на мобильный контент
    [gazetaRequest setValue:@"Firefox" forHTTPHeaderField:@"User-Agent"];
    
    dispatch_group_enter(group);
    [self enqueueRequestWithUrl:gazetaRequest success:^(id result) {
        
        NSArray *rss = [self rssArrayWithResponce:result classModel:[RSSGazetaItem class]];
        [array addObjectsFromArray:rss];
        
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        [errors addObject:error];
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        app.networkActivityIndicatorVisible = NO;
        
        //Сортировка по дате
        NSArray *sortedRss = [array sortedArrayUsingComparator: ^(RSSLentaItem *a, RSSLentaItem *b) {
            return [b.pubDate compare: a.pubDate];
        }];
        
        if(success)
            success(sortedRss);
        
        if(failure && errors.count)
            failure(errors.copy);
    });
}

-(NSArray *)rssArrayWithResponce:(id)responce classModel:(Class)classModel {
    NSParameterAssert(classModel);
    NSParameterAssert(responce);
    
    //Парсниг данных
    NSDictionary *XML = [XMLReader dictionaryForXMLData:responce
                                                options:XMLReaderOptionsProcessNamespaces
                                                  error:nil];
    //Мапинг данных
    NSArray *rss = [EKMapper arrayOfObjectsFromExternalRepresentation:XML[@"rss"][@"channel"][@"item"] withMapping:[classModel objectMapping]];
    
    return rss ? rss : @[];
}

@end