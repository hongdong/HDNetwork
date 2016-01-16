//
//  HDNetWork.m
//  MGJRequestManagerDemo
//
//  Created by Abner on 16/1/14.
//  Copyright © 2016年 juangua. All rights reserved.
//

#import "HDNetWork.h"
#import <YYCache.h>

static NSString * const HDNetWorkCacheKey = @"HDNetWorkCacheKey";
NSInteger const HDResponseCancelError = -1;

@interface HDNetWork ()

@property (nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic) NSMutableDictionary *chainedOperations;
/**
 *  避免引用 Operation 和 Block
 */
@property (nonatomic) NSMapTable *completionBlocks;
/**
 *  避免引用 Operation
 */
@property (nonatomic) NSMapTable *operationMethodParameters;
@property (nonatomic, strong) YYCache *hd_cache;
@property (nonatomic) NSMutableArray *batchGroups;

@end

@implementation HDNetWork

@synthesize configuration = _configuration;


HDSingletonM(HDNetWork)

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkStatus = AFNetworkReachabilityStatusUnknown;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        self.chainedOperations = [[NSMutableDictionary alloc] init];
        self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableCopyIn];
        self.operationMethodParameters = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        self.batchGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    self.networkStatus = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
}

#pragma mark - Public

- (AFHTTPRequestOperation *)HDGET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
               startImmediately:(BOOL)startImmediately
           configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
              completionHandler:(HDRequestManagerCompletionHandler)completionHandler
{
    return [self HTTPRequestOperationWithMethod:@"GET" URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)HDPOST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
            configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
               completionHandler:(HDRequestManagerCompletionHandler)completionHandler
{
    return [self HTTPRequestOperationWithMethod:@"POST" URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)HDPOST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
            configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
               completionHandler:(HDRequestManagerCompletionHandler)completionHandler
{
    return [self HTTPRequestOperationWithMethod:@"POST" URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:block configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)HDPUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
               startImmediately:(BOOL)startImmediately
           configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
              completionHandler:(HDRequestManagerCompletionHandler)completionHandler
{
    return [self HTTPRequestOperationWithMethod:@"PUT" URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)HDDELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                  startImmediately:(BOOL)startImmediately
              configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
                 completionHandler:(HDRequestManagerCompletionHandler)completionHandler
{
    return [self HTTPRequestOperationWithMethod:@"DELETE" URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithMethod:(NSString *)method
                                                 URLString:(NSString *)URLString
                                                parameters:(NSDictionary *)parameters
                                          startImmediately:(BOOL)startImmediately
                                 constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                      configurationHandler:(HDRequestManagerConfigurationHandler)configurationHandler
                                         completionHandler:(HDRequestManagerCompletionHandler)completionHandler{
    
    
    // 拿到 configuration 的副本，然后让调用方自定义该 configuration,作为本次请求的配置
    HDRequestManagerConfiguration *configuration = [self.configuration copy];
    if (configurationHandler) {
        configurationHandler(configuration);
    }
    self.requestOperationManager.requestSerializer = configuration.requestSerializer;
    self.requestOperationManager.responseSerializer = configuration.responseSerializer;
    
    // 如果定义过 parametersHandler，可以对 builtin parameters 和 request parameters 进行调整
    // 比如需要根据这两个值计算 token
    if (self.parametersHandler) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        NSMutableDictionary *mutableBultinParameters = [NSMutableDictionary dictionaryWithDictionary:configuration.builtinParameters];
        self.parametersHandler(mutableParameters, mutableBultinParameters);
        //对参数进行重新赋值
        parameters = [mutableParameters copy];
        configuration.builtinParameters = [mutableBultinParameters copy];
    }

    NSString *combinedURL = [URLString stringByAppendingString:[self serializeParams:configuration.builtinParameters]];
    NSMutableURLRequest *request;
    
    if (block) {
        // 如果是上传的情况，特殊处理，把 block 塞进去
        request = [self.requestOperationManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:combinedURL relativeToURL:[NSURL URLWithString:configuration.baseURL]] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    } else {
        request = [self.requestOperationManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:combinedURL relativeToURL:[NSURL URLWithString:configuration.baseURL]] absoluteString] parameters:parameters error:nil];
    }

    if (configuration.builtinHeaders.count > 0) {
        for (NSString *key in configuration.builtinHeaders) {
            [request setValue:configuration.builtinHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    // 根据 configuration 和 request 生成一个 operation
    AFHTTPRequestOperation *operation = [self createOperationWithConfiguration:configuration request:request];

    // 如果不是马上执行的话，先把参数记录下来，方便之后回放
    if (!startImmediately) {
        NSMutableDictionary *methodParameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                @"method": method,
                                                                                                @"URLString": URLString,
                                                                                                }];
        if (parameters) {
            methodParameters[@"parameters"] = parameters;
        }
        if (block) {
            methodParameters[@"constructingBodyWithBlock"] = block;
        }
        if (configurationHandler) {
            methodParameters[@"configurationHandler"] = configurationHandler;
        }
        if (completionHandler) {
            methodParameters[@"completionHandler"] = completionHandler;
        }
        
        [self.operationMethodParameters setObject:methodParameters forKey:operation];
        return operation;
    }
    
   //寻找是否有下一个Operation需要执行
    __weak typeof(self) weakSelf = self;
    void (^checkIfShouldDoChainOperation)(AFHTTPRequestOperation *) = ^(AFHTTPRequestOperation *operation){
        __strong typeof(self) strongSelf = weakSelf;
        // TODO 不用每次都去找一下 ChainedOperations
        AFHTTPRequestOperation *nextOperation = [strongSelf findNextOperationInChainedOperationsBy:operation];
        if (nextOperation) {
            NSDictionary *methodParameters = [strongSelf.operationMethodParameters objectForKey:nextOperation];
            if (methodParameters) {
                [strongSelf HTTPRequestOperationWithMethod:methodParameters[@"method"]
                                                 URLString:methodParameters[@"URLString"]
                                                parameters:methodParameters[@"parameters"]
                                          startImmediately:YES
                                 constructingBodyWithBlock:methodParameters[@"constructingBodyWithBlock"]
                                      configurationHandler:methodParameters[@"configurationHandler"]
                                         completionHandler:methodParameters[@"completionHandler"]];
                [strongSelf.operationMethodParameters removeObjectForKey:nextOperation];
            } else {
                //添加下一个请求
                [strongSelf.requestOperationManager.operationQueue addOperation:nextOperation];
            }
        }
    };
    
    // 对 request 的预处理,可中断请求
    BOOL (^shouldStopProcessingRequest)(AFHTTPRequestOperation *, id userInfo, HDRequestManagerConfiguration *) =  ^BOOL (AFHTTPRequestOperation *operation, id userInfo, HDRequestManagerConfiguration *configuration) {
        BOOL shouldStopProcessing = NO;
        
        // 先调用默认的处理
        if (weakSelf.configuration.requestHandler) {
            weakSelf.configuration.requestHandler(operation, userInfo, &shouldStopProcessing);
        }
        
        // 如果客户端有定义过 requestHandler
        if (configuration.requestHandler) {
            configuration.requestHandler(operation, userInfo, &shouldStopProcessing);
        }
        return shouldStopProcessing;
    };
    
    // 对 response 预处理
    HDResponse *(^handleResponse)(AFHTTPRequestOperation *, id,BOOL) = ^ HDResponse *(AFHTTPRequestOperation *theOperation, id responseObject,BOOL isFromCache) {
        HDResponse *response = [[HDResponse alloc] init];
        // a bit trick :)
        response.error = [responseObject isKindOfClass:[NSError class]] ? responseObject : nil;
        response.result = response.error ? nil : responseObject;
        
        BOOL shouldStopProcessing = NO;
        
        // 先调用默认的处理
        if (weakSelf.configuration.responseHandler) {
            weakSelf.configuration.responseHandler(operation, configuration.userInfo, response, &shouldStopProcessing);
        }
        
        // 如果客户端有定义过 responseHandler
        if (configuration.responseHandler) {
            configuration.responseHandler(operation, configuration.userInfo, response, &shouldStopProcessing);
        }
        
        // shouldStopProcessing 的话, completionHandler 是不会被触发的
        if (shouldStopProcessing) {
            [weakSelf.completionBlocks removeObjectForKey:theOperation];
            return response;
        }
        
        completionHandler(response.error, response.result, isFromCache, theOperation);
        [weakSelf.completionBlocks removeObjectForKey:theOperation];
        
        checkIfShouldDoChainOperation(theOperation);
        return response;
    };
    //如果是GET请求，则要做缓存处理
    
    if ([method isEqualToString:@"GET"]) {
        NSString *urlKey = [URLString stringByAppendingString:[self serializeParams:parameters]];
        id result = [self.hd_cache objectForKey:urlKey];
        switch (configuration.hd_requestCachePolicy) {
            case HDRequestCachePolicyReturnCacheDataThenLoad:{//先返回缓存，然后再请求
                if (result) {
                    if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
                        handleResponse(operation, result, YES);
                    } else {
                        NSError *error = [NSError errorWithDomain:@"取消请求" code:HDResponseCancelError userInfo:nil];
                        handleResponse(operation, error, NO);
                        //如果shouldStopProcessing为YES则直接返回，不继续往下进行
                        return operation;
                    }
                }

                break;
            }
            case HDRequestCachePolicyReloadIgnoringLocalCacheData:{//忽略本地缓存直接请求
            
            }
                break;

            case HDRequestCachePolicyReturnCacheDataElseLoad:{//有缓存就返回缓存，没有就请求
                if (result) {//有缓存
                    if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
                        handleResponse(operation, result, YES);
                    } else {
                        NSError *error = [NSError errorWithDomain:@"取消请求" code:HDResponseCancelError userInfo:nil];
                        handleResponse(operation, error, NO);

                    }
                    //如果有缓存则直接返回，不继续往下进行
                    return operation;
                }
                break;
            }
            case HDRequestCachePolicyReturnCacheDataDontLoad:{//有缓存就返回缓存,从不请求（用于没有网络）
                if (result) {//有缓存
                    if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
                        handleResponse(operation, result, YES);
                    } else {
                        NSError *error = [NSError errorWithDomain:@"取消请求" code:HDResponseCancelError userInfo:nil];
                        handleResponse(operation, error, NO);
                        
                    }

                }
                //如果有缓存则直接返回，从不请求
                return operation;//退出从不请求
                break;
            }
                
            default:
                break;
                
        }
    }
    //异步执行请求
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *theOperation, id responseObject){
        HDResponse *response = handleResponse(theOperation, responseObject,NO);
        
        // 如果使用缓存，就把结果放到缓存中方便下次使用
        if (configuration.resultCacheDuration > 0 && [method isEqualToString:@"GET"] && !response.error) {
            // 不使用 builtinParameters, 因为 builtin parameters 可能有时间这样的变量
            NSString *urlKey = [URLString stringByAppendingString:[self serializeParams:parameters]];
            [weakSelf.hd_cache setObject:response.result forKey:urlKey];
        }
    } failure:^(AFHTTPRequestOperation *theOperation, NSError *error){
        handleResponse(theOperation, error,NO);
    }];
    
    //对request做预处理、并且判断有没有中断
    if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
        [self.requestOperationManager.operationQueue addOperation:operation];
    } else {
        NSError *error = [NSError errorWithDomain:@"取消请求" code:HDResponseCancelError userInfo:nil];
        handleResponse(operation, error,NO);
    }

    [self.completionBlocks setObject:operation.completionBlock forKey:operation];
    
    return operation;
}

/**
 *  根据配置和request生成AFHTTPRequestOperation
 *
 *  @return AFHTTPRequestOperation
 */

- (AFHTTPRequestOperation *)createOperationWithConfiguration:(HDRequestManagerConfiguration *)configuration request:(NSURLRequest *)request
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.requestOperationManager.responseSerializer;
    operation.shouldUseCredentialStorage = self.requestOperationManager.shouldUseCredentialStorage;
    operation.credential = self.requestOperationManager.credential;
    operation.securityPolicy = self.requestOperationManager.securityPolicy;
    operation.completionQueue = self.requestOperationManager.completionQueue;
    operation.completionGroup = self.requestOperationManager.completionGroup;
    return operation;
}

/**
 *  从 Chained Operations 中找到该 Operation 对应的下一个 Operation
 *  注意：会从 Chain 中移除该 Operation!
 */
- (AFHTTPRequestOperation *)findNextOperationInChainedOperationsBy:(AFHTTPRequestOperation *)operation
{
    //TODO 这个实现有优化空间
    __block AFHTTPRequestOperation *theOperation;
    __weak typeof(self) weakSelf = self;
    
    [self.chainedOperations enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *chainedOperations, BOOL *stop) {
        [chainedOperations enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *requestOperation, NSUInteger idx, BOOL *stop) {
            if (requestOperation == operation) {
                if (idx < chainedOperations.count - 1) {
                    theOperation = chainedOperations[idx + 1];
                    *stop = YES;
                }
                [chainedOperations removeObject:requestOperation];
                // 同时移除对要返回的 operation 的引用
                [chainedOperations removeObject:theOperation];
            }
        }];
        if (chainedOperations) {
            *stop = YES;
        }
        if (!chainedOperations.count) {
            [weakSelf.chainedOperations removeObjectForKey:key];
        }
    }];
    
    return theOperation;
}

/**
 *  开始执行一个operation
 *  @return newOperation
 */

- (AFHTTPRequestOperation *)startOperation:(AFHTTPRequestOperation *)operation
{
    NSDictionary *methodParameters = [self.operationMethodParameters objectForKey:operation];
    AFHTTPRequestOperation *newOperation = operation;
    if (methodParameters) {
        newOperation = [self HTTPRequestOperationWithMethod:methodParameters[@"method"]
                                                  URLString:methodParameters[@"URLString"]
                                                 parameters:methodParameters[@"parameters"]
                                           startImmediately:YES
                                  constructingBodyWithBlock:methodParameters[@"constructingBodyWithBlock"]
                                       configurationHandler:methodParameters[@"configurationHandler"]
                                          completionHandler:methodParameters[@"completionHandler"]];
        [self.operationMethodParameters removeObjectForKey:operation];
    } else {
        [self.requestOperationManager.operationQueue addOperation:operation];
    }
    return newOperation;
}
/**
 *  取消一个请求
 *
 *  @param method 请求方法
 *  @param url    请求URL
 */
- (void)cancelHTTPOperationsWithMethod:(NSString *)method url:(NSString *)url
{
    NSError *error;
    
    NSString *pathToBeMatched = [[[self.requestOperationManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:url] absoluteString] parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [self.requestOperationManager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingMethod = !method || [method  isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}

/**
 *  添加一个请求operation到指定的chain中
 *
 *  @param operation 请求operation
 *  @param chain     chain名字
 */

- (void)addOperation:(AFHTTPRequestOperation *)operation toChain:(NSString *)chain
{
    NSString *chainName = chain ? : @"";
    if (!self.chainedOperations[chainName]) {
        self.chainedOperations[chainName] = [[NSMutableArray alloc] init];
    }
    
    // 只启动第一个，其余的在第一个执行完后会依次执行
    if (!((NSMutableArray *)self.chainedOperations[chainName]).count) {
        operation = [self startOperation:operation];
    }
    
    [self.chainedOperations[chainName] addObject:operation];
}

- (NSArray *)operationsInChain:(NSString *)chain
{
    return self.chainedOperations[chain];
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation inChain:(NSString *)chain
{
    NSString *chainName = chain ? : @"";
    if (self.chainedOperations[chainName]) {
        NSMutableArray *chainedOperations = self.chainedOperations[chainName];
        [chainedOperations removeObject:operation];
    }
}

- (void)removeOperationsInChain:(NSString *)chain
{
    NSString *chainName = chain ? : @"";
    NSMutableArray *chainedOperations = self.chainedOperations[chainName];
    chainedOperations ? [chainedOperations removeAllObjects] : @"do nothing";
}

- (void)batchOfRequestOperations:(NSArray *)operations
                   progressBlock:(void (^)(NSUInteger, NSUInteger))progressBlock
                 completionBlock:(void (^)())completionBlock
{
    __block dispatch_group_t group = dispatch_group_create();
    [self.batchGroups addObject:group];
    __block NSInteger finishedOperationsCount = 0;
    NSInteger totalOperationsCount = operations.count;
    
    [operations enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *operation, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *operationMethodParameters = [NSMutableDictionary dictionaryWithDictionary:[self.operationMethodParameters objectForKey:operation]];
        if (operationMethodParameters) {
            dispatch_group_enter(group);
            HDRequestManagerCompletionHandler originCompletionHandler = [(HDRequestManagerCompletionHandler) operationMethodParameters[@"completionHandler"] copy];
            
            HDRequestManagerCompletionHandler newCompletionHandler = ^(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *theOperation) {
                if (!isFromCache) {
                    if (progressBlock) {
                        progressBlock(++finishedOperationsCount, totalOperationsCount);
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (originCompletionHandler) {
                        originCompletionHandler(error, result, isFromCache, theOperation);
                    }
                    dispatch_group_leave(group);
                });
            };
            operationMethodParameters[@"completionHandler"] = newCompletionHandler;
            
            [self.operationMethodParameters setObject:operationMethodParameters forKey:operation];
            [self startOperation:operation];
            
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.batchGroups removeObject:group];
        if (completionBlock) {
            completionBlock();
        }
    });
}

- (AFHTTPRequestOperation *)reAssembleOperation:(AFHTTPRequestOperation *)operation
{
    AFHTTPRequestOperation *newOperation = [operation copy];
    newOperation.completionBlock = [self.completionBlocks objectForKey:operation];
    // 及时移除，避免循环引用
    [self.completionBlocks removeObjectForKey:operation];
    return newOperation;
}



/**
 *  参数序列化
 *
 *  @param params params 参数
 *
 *  @return return value 参数字符串
 */

-(NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *encodedValue = [obj.description stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    return queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
}


- (void)cancelAllRequest
{
    [self.requestOperationManager.operationQueue cancelAllOperations];
}

- (NSArray *)runningRequests
{
    return self.requestOperationManager.operationQueue.operations;
}


/**
 *  GET、SET方法
 *
 *  @return
 */

- (AFHTTPRequestOperationManager *)requestOperationManager
{
    if (!_requestOperationManager) {
        _requestOperationManager = [AFHTTPRequestOperationManager manager] ;
    }
    return _requestOperationManager;
}

- (HDRequestManagerConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [[HDRequestManagerConfiguration alloc] init];
    }
    return _configuration;
}

- (void)setConfiguration:(HDRequestManagerConfiguration *)configuration
{
    if (_configuration != configuration) {
        _configuration = configuration;
        if (_configuration.resultCacheDuration > 0) {
            self.hd_cache.memoryCache.ageLimit = _configuration.resultCacheDuration;
            self.hd_cache.diskCache.ageLimit = _configuration.resultCacheDuration;

        }
    }
}

-(YYCache *)hd_cache{
    if (!_hd_cache) {
        _hd_cache = [[YYCache alloc] initWithName:HDNetWorkCacheKey];
        _hd_cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _hd_cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _hd_cache;
}



@end
