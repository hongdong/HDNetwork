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
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodGET url:url parameters:parameters];
}


/**
 RAC POST请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_POSTWithURL:(NSString *)url
                    parameters:(NSDictionary *)parameters{
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodPOST url:url parameters:parameters];
}

/**
 RAC HEAD请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_HEADWithURL:(NSString *)url
                    parameters:(NSDictionary *)parameters{
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodHEAD url:url parameters:parameters];
}


/**
 RAC PUT请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_PUTWithURL:(NSString *)url
                   parameters:(NSDictionary *)parameters{
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodPUT url:url parameters:parameters];
}



/**
 RAC PATCH请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_PATCHWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters{
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodPATCH url:url parameters:parameters];
}


/**
 RAC DELETE请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_DELETEWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters{
    return [self rac_HTTPUnCacheWithMethod:HDRequestMethodDELETE url:url parameters:parameters];
}

/**
 RACGET支持缓存请求方式
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_HTTPGetUrl:(NSString *)url
                   parameters:(NSDictionary *)parameters
                  cachePolicy:(HDCachePolicy)cachePolicy{
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HDNetwork HTTPGetUrl:url parameters:parameters cachePolicy:cachePolicy callback:^(id responseObject, NSError *error, BOOL isFromCache) {
            
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

+ (RACSignal *)rac_HTTPUnCacheWithMethod:(HDRequestMethod)method
                              url:(NSString *)url
                       parameters:(NSDictionary *)parameters{
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [HDNetwork HTTPUnCacheWithMethod:method url:url parameters:parameters callback:^(id responseObject, NSError *error, BOOL isFromCache) {
            
            if (error) {
                
                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                if (responseObject) {
                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
                }
                NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
                [subscriber sendError:errorWithRes];
                
            } else {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            }
            
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return requestSignal;
}
@end
