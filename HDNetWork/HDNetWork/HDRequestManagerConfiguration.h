//
//  HDRequestManagerConfiguration.h
//  Demo
//
//  Created by Abner on 16/1/14.
//  Copyright © 2016年 juangua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "HDResponse.h"

typedef NS_ENUM(NSUInteger, HDRequestCachePolicy){
    HDRequestCachePolicyReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
    HDRequestCachePolicyReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
    HDRequestCachePolicyReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    HDRequestCachePolicyReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

@interface HDRequestManagerConfiguration : NSObject<NSCopying>

/**
 *  请求缓存策略
 */
@property (nonatomic, assign) HDRequestCachePolicy hd_requestCachePolicy;

/**
 *  缓存时间。单位为秒，只针对GET有效
 */
@property (nonatomic, assign) NSInteger resultCacheDuration;

/**
 *  这个大家都懂什么意思
 */
@property (nonatomic, copy) NSString *baseURL;

/**
 *  默认使用 AFHTTPRequestSerializer
 */
@property (nonatomic,strong) AFHTTPRequestSerializer *requestSerializer;

/**
 *  默认使用 AFHTTPResponseSerializer
 */
@property (nonatomic,strong) AFHTTPResponseSerializer *responseSerializer;

/**
 * 可以对返回的数据做一些预处理
 * 设置 *shouldStopProcessing 为 YES 不会触发 CompletionHandler，可以用在 refreshToken
 */
@property (nonatomic, copy) void (^responseHandler)(AFHTTPRequestOperation *operation, id userInfo, HDResponse *response, BOOL *shouldStopProcessing);

/**
 *  发送数据之前可以做一些预处理，如果觉得可以取消此次发送，设置 *shouldStopProcessing 为 YES 即可
 */
@property (nonatomic, copy) void (^requestHandler)(AFHTTPRequestOperation *operation, id userInfo, BOOL *shouldStopProcessing);

/**
 *  此次请求可以附带的信息，会传给 preRequestHandler 和 postRequestHandler
 */
@property (nonatomic,strong) id userInfo;

/**
 *  每次请求都要带上的一些参数
 */
@property (nonatomic,strong) NSDictionary *builtinParameters;

@property (nonatomic,strong) NSDictionary *builtinHeaders;

@end
