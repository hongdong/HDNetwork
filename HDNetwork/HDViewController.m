//
//  HDViewController.m
//  HDNetwork
//
//  Created by Abner on 04/19/2018.
//  Copyright (c) 2018 Abner. All rights reserved.
//

#import "HDViewController.h"
#import "HDNetwork.h"
#import "HDNetwork+RAC.h"

@interface HDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cacheSegment;

@end

@implementation HDViewController
{
    HDCachePolicy cachePolicy;
    HDRequestMethod method;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"---->%@",NSHomeDirectory());
    //DEMO 默认GET请求
    method = HDRequestMethodGET;
    
    //开启控制台log
    [HDNetwork setLogEnabled:YES];
//    [HDNetwork setBaseURL:@"https://atime.com/app/v1/"];
//    [HDNetwork setFiltrationCacheKey:@[@"time",@"ts"]];
    [HDNetwork setRequestTimeoutInterval:60.0f];
    
    //按App版本号缓存网络请求内容 可修改版本号查看效果 或 使用自定义版本号方法
    [HDNetwork setCacheVersionEnabled:NO];
    
    //网络状态
    __weak __typeof(&*self)weakSelf = self;
    [HDNetwork getNetworkStatusWithBlock:^(HDNetworkStatusType status) {
        weakSelf.stateLabel.text = [NSString stringWithFormat:@"当前网络:%@",[weakSelf getStateStr:status]];
    }];
    
    //演示请求
    [self request:_requestBtn];
}

/**修改缓存策略*/
- (IBAction)changeCachePolicy:(UISegmentedControl *)sender {
    
    cachePolicy = sender.selectedSegmentIndex;
    _cacheLabel.text = [self getCacheStr:cachePolicy];
    
}

/**修改请求方法*/
- (IBAction)changeMethod:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex > 0) {
        _cacheLabel.text = @"除了GET以外的请求不需要缓存";
        self.cacheSegment.selectedSegmentIndex = 0;
        self.cacheSegment.enabled = NO;
    }
    else{
        self.cacheSegment.enabled = YES;
    }
    
    
    method = sender.selectedSegmentIndex;
    
}

/**请求*/
- (IBAction)request:(UIButton *)sender {
    sender.enabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    if (HDRequestMethodGET == method) {
        [HDNetwork HTTPGetUrl:_urlTextField.text parameters:nil cachePolicy:cachePolicy callback:^(id responseObject, NSError *error, BOOL isFromCache) {
            sender.enabled = YES;
            if (!error) {
                weakSelf.responseTextView.text = [NSString stringWithFormat:@"%@",responseObject];
            }else{
                weakSelf.responseTextView.text = [error localizedDescription];
                NSLog(@"---->%@",@"错误");
            }
        }];
    }
    else{
        [HDNetwork HTTPUnCacheWithMethod:method url:_urlTextField.text parameters:nil callback:^(id responseObject, NSError *error, BOOL isFromCache) {
            sender.enabled = YES;
            if (!error) {
                weakSelf.responseTextView.text = [NSString stringWithFormat:@"%@",responseObject];
            }else{
                weakSelf.responseTextView.text = [error localizedDescription];
                NSLog(@"---->%@",@"错误");
            }
        }];
    }

    
}

/**取消请求*/
- (IBAction)cancelRequest:(UIButton *)sender {
    [HDNetwork cancelRequestWithURL:_urlTextField.text];
    _requestBtn.enabled = YES;
}

/**清空*/
- (IBAction)empty:(UIButton *)sender {
    _responseTextView.text = @"";
}

/**清除缓存*/
- (IBAction)clearRequest:(UIButton *)sender {
    sender.enabled = NO;
    [HDNetwork removeAllHttpCacheBlock:nil endBlock:^(BOOL error) {
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
    }];
}


/**获取网络状态*/
- (NSString *)getStateStr:(HDNetworkStatusType)status
{
    switch (status) {
        case HDNetworkStatusUnknown:
            return @"未知网络";
            break;
        case HDNetworkStatusNotReachable:
            return @"无网路";
            break;
        case HDNetworkStatusReachableWWAN:
            return @"手机网络";
            break;
        case HDNetworkStatusReachableWiFi:
            return @"WiFi网络";
            break;
        default:
            break;
    }
}

/**获取网络状态*/
- (NSString *)getCacheStr:(HDCachePolicy)cache
{
    switch (cache) {
        case HDCachePolicyIgnoreCache:
            return @"只从网络获取数据，且数据不会缓存在本地";
            break;
        case HDCachePolicyCacheOnly:
            return @"只从缓存读数据，如果缓存没有数据，返回一个空";
            break;
        case HDCachePolicyNetworkOnly:
            return @"先从网络获取数据，同时会在本地缓存数据";
            break;
        case HDCachePolicyCacheElseNetwork:
            return @"先从缓存读取数据，如果没有再从网络获取";
            break;
        case HDCachePolicyNetworkElseCache:
            return @"先从网络获取数据，如果没有再从缓存读取数据，此处的没有可以理解为访问网络失败，再从缓存读取数据";
            break;
        case HDCachePolicyCacheThenNetwork:
            return @"先从缓存读取数据，然后在从网络获取并且缓存，Block将产生两次调用";
            break;
        default:
            break;
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
