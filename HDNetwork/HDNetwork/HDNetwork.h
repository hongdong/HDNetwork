//
//  HDNetwork.h
//  HDNetwork
//
//  Created by Abner on 18/4/19.
//  Copyright © 2018年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YYCache, AFHTTPSessionManager;

typedef NS_ENUM(NSUInteger, HDCachePolicy){
    /**只从网络获取数据，且数据不会缓存在本地*/
    HDCachePolicyIgnoreCache = 0,
    /**只从缓存读数据，如果缓存没有数据，返回一个空*/
    HDCachePolicyCacheOnly = 1,
    /**先从网络获取数据，同时会在本地缓存数据*/
    HDCachePolicyNetworkOnly = 2,
    /**先从缓存读取数据，如果没有再从网络获取*/
    HDCachePolicyCacheElseNetwork = 3,
    /**先从网络获取数据，如果没有在从缓存获取，此处的没有可以理解为访问网络失败，再从缓存读取*/
    HDCachePolicyNetworkElseCache = 4,
    /**先从缓存读取数据，然后在从网络获取并且缓存，在这种情况下，Block将产生两次调用*/
    HDCachePolicyCacheThenNetwork = 5
};

/**请求方式*/
typedef NS_ENUM(NSUInteger, HDRequestMethod){
    /**GET请求方式*/
    HDRequestMethodGET = 0,
    /**POST请求方式*/
    HDRequestMethodPOST,
    /**HEAD请求方式*/
    HDRequestMethodHEAD,
    /**PUT请求方式*/
    HDRequestMethodPUT,
    /**PATCH请求方式*/
    HDRequestMethodPATCH,
    /**DELETE请求方式*/
    HDRequestMethodDELETE
};

typedef NS_ENUM(NSUInteger, HDNetworkStatusType){
    /**未知网络*/
    HDNetworkStatusUnknown,
    /**无网路*/
    HDNetworkStatusNotReachable,
    /**手机网络*/
    HDNetworkStatusReachableWWAN,
    /**WiFi网络*/
    HDNetworkStatusReachableWiFi
};

typedef NS_ENUM(NSUInteger, HDRequestSerializer){
    /**设置请求数据为JSON格式*/
    HDRequestSerializerJSON,
    /**设置请求数据为二进制格式*/
    HDRequestSerializerHTTP
};

typedef NS_ENUM(NSUInteger, HDResponseSerializer) {
    /**设置响应数据为JSON格式*/
    HDResponsetSerializerJSON,
    /**设置响应数据为二进制格式*/
    HDResponseSerializerHTTP
};

/**请求的Block*/
typedef void(^HDHttpRequest)(id responseObject, NSError *error, BOOL isFromCache);

/**下载的Block*/
typedef void(^HDHttpDownload)(NSString *path, NSError *error);

/*上传或者下载的进度*/
typedef void(^HDHttpProgress)(NSProgress *progress);

/**网络状态Block*/
typedef void(^HDNetworkStatus)(HDNetworkStatusType status);

/**网络错误统一拦截处理*/
typedef NSError *(^ErrorReduceBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

/**请求结果拦截处理*/
typedef id(^ResponseReduceBlock)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject);



@interface HDNetwork : NSObject

/**是否按App版本号缓存网络请求内容(默认关闭)*/
+ (void)setCacheVersionEnabled:(BOOL)bFlag;

/**使用自定义缓存版本号*/
+ (void)setCacheVersion:(NSString*)version;

/**输出Log信息开关(默认打开)*/
+ (void)setLogEnabled:(BOOL)bFlag;

/**过滤缓存Key*/
+ (void)setFiltrationCacheKey:(NSArray *)filtrationCacheKey;

/**设置接口根路径, 设置后所有的网络访问都使用相对路径 尽量以"/"结束*/
+ (void)setBaseURL:(NSString *)baseURL;

/** 设置接口请求头 */
+ (void)setHeadr:(NSDictionary *)heder;

/**设置接口基本参数(如:用户ID, Token)*/
+ (void)setBaseParameters:(NSDictionary *)parameters;

/**设置统一预处理结果*/
+ (void)setResponseReduceBlock:(ResponseReduceBlock)responseReduceBlock;

/**设置统一预处理错误*/
+ (void)setErrorReduceBlock:(ErrorReduceBlock)errorReduceBlock;

/**实时获取网络状态*/
+ (void)getNetworkStatusWithBlock:(HDNetworkStatus)networkStatus;

/**判断是否有网*/
+ (BOOL)isNetwork;

/**是否是手机网络*/
+ (BOOL)isWWANNetwork;

/**是否是WiFi网络*/
+ (BOOL)isWiFiNetwork;

/**取消所有Http请求*/
+ (void)cancelAllRequest;

/**取消指定URL的Http请求*/
+ (void)cancelRequestWithURL:(NSString *)url;

/**设置请求超时时间(默认30s) */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**是否打开网络加载菊花(默认打开)*/
+ (void)openNetworkActivityIndicator:(BOOL)open;


/**
 GET请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)GETWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
       cachePolicy:(HDCachePolicy)cachePolicy
           callback:(HDHttpRequest)callback;


/**
 POST请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HDCachePolicy)cachePolicy
            callback:(HDHttpRequest)callback;

/**
 HEAD请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)HEADWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HDCachePolicy)cachePolicy
            callback:(HDHttpRequest)callback;


/**
 PUT请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)PUTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HDCachePolicy)cachePolicy
            callback:(HDHttpRequest)callback;



/**
 PATCH请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)PATCHWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HDCachePolicy)cachePolicy
            callback:(HDHttpRequest)callback;


/**
 DELETE请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)DELETEWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HDCachePolicy)cachePolicy
            callback:(HDHttpRequest)callback;


/**
 自定义请求方式
 
 @param method 请求方式(GET, POST, HEAD, PUT, PATCH, DELETE)
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)HTTPWithMethod:(HDRequestMethod)method
                    url:(NSString *)url
             parameters:(NSDictionary *)parameters
            cachePolicy:(HDCachePolicy)cachePolicy
                callback:(HDHttpRequest)callback;


/**
 上传文件
 
 @param url 请求地址
 @param parameters 请求参数
 @param name 文件对应服务器上的字段
 @param filePath 文件路径
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                     name:(NSString *)name
                 filePath:(NSString *)filePath
                 progress:(HDHttpProgress)progress
                  callback:(HDHttpRequest)callback;


/**
 上传图片文件

 @param url 请求地址
 @param parameters 请求参数
 @param images 图片数组
 @param name 文件对应服务器上的字段
 @param fileName 文件名
 @param mimeType 图片文件类型：png/jpeg(默认类型)
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadImageURL:(NSString *)url
       parameters:(NSDictionary *)parameters
           images:(NSArray<UIImage *> *)images
             name:(NSString *)name
         fileName:(NSString *)fileName
         mimeType:(NSString *)mimeType
         progress:(HDHttpProgress)progress
          callback:(HDHttpRequest)callback;


/**
 下载文件

 @param url 请求地址
 @param fileDir 文件存储的目录(默认存储目录为Download)
 @param progress 文件下载的进度信息
 @param callback 请求回调
 */
+ (void)downloadWithURL:(NSString *)url
                fileDir:(NSString *)fileDir
               progress:(HDHttpProgress)progress
                callback:(HDHttpDownload)callback;


#pragma mark -- 网络缓存

/**
 *  获取YYCache对象
 */
+ (YYCache *)getYYCache;

/**
 *  异步缓存网络数据,根据请求的 URL与parameters
 *  做Key存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param url        请求的URL地址
 *  @param parameters 请求的参数
 */
+ (void)setHttpCache:(id)httpData url:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  根据请求的 URL与parameters 异步取出缓存数据
 *
 *  @param url        请求的URL
 *  @param parameters 请求的参数
 *  @param block      异步回调缓存的数据
 *
 */
+ (void)httpCacheForURL:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(void(^)(id responseObject))block;

/**
 *  磁盘最大缓存开销大小 bytes(字节)
 */
+ (void)setCostLimit:(NSInteger)costLimit;

/**
 *  获取网络缓存的总大小 bytes(字节)
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 *  获取网络缓存的总大小 bytes(字节)
 *  推荐使用该方法 不会阻塞主线程，通过block返回
 */
+ (void)getAllHttpCacheSizeBlock:(void(^)(NSInteger totalCount))block;

/**
 *  删除所有网络缓存
 */
+ (void)removeAllHttpCache;

/**
 *  删除所有网络缓存
 *  推荐使用该方法 不会阻塞主线程，同时返回Progress
 */
+ (void)removeAllHttpCacheBlock:(void(^)(int removedCount, int totalCount))progress
                       endBlock:(void(^)(BOOL error))end;

#pragma mark -- 重置AFHTTPSessionManager相关属性

/**
 *  获取AFHTTPSessionManager对象
 */
+ (AFHTTPSessionManager *)getAFHTTPSessionManager;

/**
 设置网络请求参数的格式:默认为JSON格式

 @param requestSerializer HDRequestSerializerJSON---JSON格式  HDRequestSerializerHTTP--HTTP
 */
+ (void)setRequestSerializer:(HDRequestSerializer)requestSerializer;



/**
 设置服务器响应数据格式:默认为JSON格式

 @param responseSerializer HDResponseSerializerJSON---JSON格式  HDResponseSerializerHTTP--HTTP

 */
+ (void)setResponseSerializer:(HDResponseSerializer)responseSerializer;


/**
 设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 配置自建证书的Https请求，参考链接:http://blog.csdn.net/syg90178aw/article/details/52839103

 @param cerPath 自建https证书路径
 @param validatesDomainName 是否验证域名(默认YES) 如果证书的域名与请求的域名不一致，需设置为NO
 服务器使用其他信任机构颁发的证书也可以建立连接，但这个非常危险，建议打开 .validatesDomainName=NO,主要用于这种情况:客户端请求的是子域名，而证书上是另外一个域名。因为SSL证书上的域名是独立的
 For example:证书注册的域名是www.baidu.com,那么mail.baidu.com是无法验证通过的
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

#pragma mark -- 拼接URL工具

/**
 向URL的占位符中依次插入数组中的参数，识别:XXX(英文冒号)占位符
 */
+ (NSString *)HDGenerateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;


@end
