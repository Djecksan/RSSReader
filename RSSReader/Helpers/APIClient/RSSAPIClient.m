//
//  RSSAPIClient.m
//  RSSReader
//
//  Created by Evgenyi Tyulenev on 30.04.15.
//  Copyright (c) 2015 Code. All rights reserved.
//

#import "RSSAPIClient.h"
#import "AFNetworking.h"


@interface RSSAPIClient()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation RSSAPIClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)enqueueRequestWithUrl:(NSURLRequest *)request
                      success:(RSSAPIClientSuccess)success
                      failure:(RSSAPIClientFailure)failure {
    
    //создаем операцию
    AFHTTPRequestOperation *op = [self operationWithRequest:request];
    
    //ждем отвта
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if(success)
            success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
        NSLog(@"Error: %@", error);
#endif
        if(failure)
            failure(error);
    }];
    
    [op setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *r, NSURLResponse *redirectResponse) {
        return r;
    }];
    
    //добавляем запрос в очередь
    [self.operationQueue addOperation:op];
}

-(NSMutableURLRequest *)requestWithURLString:(NSString *)url andParameters:(NSDictionary *)parameters andMethod:(NSString *)method {
    NSMutableURLRequest *request = (NSMutableURLRequest *)[self requestWithMethod:method requestSerializer:[AFHTTPRequestSerializer serializer] URLString:url parameters:parameters];
    return request;
}

#pragma mark - Private Methods

-(AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return operation;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method requestSerializer:(id<AFURLRequestSerialization>)serializer URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return (NSMutableURLRequest *)[serializer requestBySerializingRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] withParameters:parameters error:nil];
}

@end
