//
//  HDNetwork+RAC.m
//  HDNetwork
//
//  Created by Abner on 2018/5/8.
//  Copyright © 2018年 Abnerh. All rights reserved.
//

#import "HDNetwork+RAC.h"
#import <ReactiveObjC.h>

static NSString *const RACAFNResponseObjectErrorKey = @"responseObject";


@implementation HDNetwork (RAC)

/**
 RAC GET请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_GETWithURL:(NSString *)url
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodGET url:url parameters:parameters cachePolicy:cachePolicy];
}


/**
 RAC POST请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_POSTWithURL:(NSString *)url
                    parameters:(NSDictionary *)parameters
                   cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodPOST url:url parameters:parameters cachePolicy:cachePolicy];
}

/**
 RAC HEAD请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_HEADWithURL:(NSString *)url
                    parameters:(NSDictionary *)parameters
                   cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodHEAD url:url parameters:parameters cachePolicy:cachePolicy];
}


/**
 RAC PUT请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_PUTWithURL:(NSString *)url
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodPUT url:url parameters:parameters cachePolicy:cachePolicy];
}



/**
 RAC PATCH请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_PATCHWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                    cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodPATCH url:url parameters:parameters cachePolicy:cachePolicy];
}


/**
 RAC DELETE请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_DELETEWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
                     cachePolicy:(HDCachePolicy)cachePolicy{
    return [self rac_HTTPWithMethod:HDRequestMethodDELETE url:url parameters:parameters cachePolicy:cachePolicy];
}

/**
 RAC自定义请求方式
 
 @param method 请求方式(GET, POST, HEAD, PUT, PATCH, DELETE)
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_HTTPWithMethod:(HDRequestMethod)method
                          url:(NSString *)url
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(HDCachePolicy)cachePolicy{
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HDNetwork HTTPWithMethod:method url:url parameters:parameters cachePolicy:cachePolicy callback:^(id responseObject, NSError *error, BOOL isFromCache) {
            
            if (error) {
                
                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
                [subscriber sendError:errorWithRes];
                
            } else {
                
                [subscriber sendNext:responseObject];
                
                if (!(HDCachePolicyCacheThenNetwork == cachePolicy && isFromCache)) {
                    [subscriber sendCompleted];
                }
                
            }
            
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    return requestSignal;
    
}
@end
