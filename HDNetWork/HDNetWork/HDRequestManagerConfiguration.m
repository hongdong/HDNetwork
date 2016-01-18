//
//  HDRequestManagerConfiguration.m
//  Demo
//
//  Created by Abner on 16/1/14.
//  Copyright © 2016年 juangua. All rights reserved.
//

#import "HDRequestManagerConfiguration.h"

@implementation HDRequestManagerConfiguration
- (AFHTTPRequestSerializer *)requestSerializer
{
    return _requestSerializer ? : [AFHTTPRequestSerializer serializer];
}

- (AFHTTPResponseSerializer *)responseSerializer
{
    return _responseSerializer ? : [AFJSONResponseSerializer serializer];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    HDRequestManagerConfiguration *configuration = [[HDRequestManagerConfiguration alloc] init];
    configuration.baseURL = [self.baseURL copy];
    configuration.hd_requestCachePolicy = self.hd_requestCachePolicy;
    configuration.resultCacheDuration = self.resultCacheDuration;
    configuration.builtinParameters = [self.builtinParameters copy];
    configuration.userInfo = [self.userInfo copy];
    configuration.builtinHeaders = [self.builtinParameters copy];
    return configuration;
}
@end
