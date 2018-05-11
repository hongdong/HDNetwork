//
//  HDNetwork+RAC.h
//  HDNetwork
//
//  Created by 洪东 on 2018/5/8.
//  Copyright © 2018年 Abnerh. All rights reserved.
//

#import "HDNetwork.h"

/**
 RAC请求便捷宏
 */
#define HDRACGETP(_URL_,_urlParmArr_,_parmDic_,_cachePolicy_) ([HDNetwork rac_GETWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_ cachePolicy:_cachePolicy_])

#define HDRACGET(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_GETWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_ cachePolicy:HDCachePolicyIgnoreCache])

#define HDRACPOST(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_POSTWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_])

#define HDRACHEAD(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_HEADWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_])

#define HDRACPUT(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_PUTWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_])

#define HDRACPATCH(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_PATCHWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_])

#define HDRACDELETE(_URL_,_urlParmArr_,_parmDic_) ([HDNetwork rac_DELETEWithURL:[HDNetwork HDGenerateURLWithPattern:_URL_ parameters:_urlParmArr_] parameters:_parmDic_])

@class RACSignal;

@interface HDNetwork (RAC)

/**
 RAC GET请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_GETWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
       cachePolicy:(HDCachePolicy)cachePolicy;


/**
 RAC POST请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters;

/**
 RAC HEAD请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_HEADWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters;


/**
 RAC PUT请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_PUTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters;



/**
 RAC PATCH请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_PATCHWithURL:(NSString *)url
          parameters:(NSDictionary *)parameters;


/**
 RAC DELETE请求
 
 @param url 请求地址
 @param parameters 请求参数
 */
+ (RACSignal *)rac_DELETEWithURL:(NSString *)url
           parameters:(NSDictionary *)parameters;

/**
 RAC GET支持缓存请求方式
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 */
+ (RACSignal *)rac_HTTPGetUrl:(NSString *)url
            parameters:(NSDictionary *)parameters
           cachePolicy:(HDCachePolicy)cachePolicy;

/**
 RAC 无缓存请求方式
 
 @param method 请求方式(GET, POST, HEAD, PUT, PATCH, DELETE)
 @param url 请求地址
 @param parameters 请求参数
 */

+ (RACSignal *)rac_HTTPUnCacheWithMethod:(HDRequestMethod)method
                    url:(NSString *)url
                    parameters:(NSDictionary *)parameters;

@end
