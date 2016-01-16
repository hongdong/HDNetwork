//
//  MacroHeader.h
//  
//
//  Created by 洪东 on 15/3/31.
//  Copyright (c) 2015年 洪东. All rights reserved.
//

#ifndef ezhuang365_MacroHeader_h
#define ezhuang365_MacroHeader_h

#ifdef __OBJC__
#endif



#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//通知的常量

//通知宏
#define HDNotiReadChange @"HDNotiReadChange"
#define HDNotiShouldBeLogin @"HDNotiShouldBeLogin"
#define HDNotiUserInfoUpdate @"HDNotiUserInfoUpdate"
#define HDClickApnsNotiInto @"HDClickApnsNotiInto"
#define HDNotiHasLogout @"HDNotiHasLogout"
#define HDNotiFreshBadge @"HDNotiFreshBadges"
#define HDNotiFreshWeixinBinding @"HDNotiFreshWeixinBinding"
#define HDNotiDeleteAskBuy @"HDNotiDeleteAskBuy"
#define HDNotiPublicProduct @"HDNotiPublicProduct"
#define HDNotiFavoriteAskBuy @"HDNotiFavoriteAskBuy"
#define HDNotiPushToRecycle @"HDNotiPushToRecycle"
#define HDShouldFreshMessage @"HDShouldFreshMessage"
#define HDWillLogout         @"HDWillLogout"
#define HDWillLogin            @"HDWillLogin"

#define HDNotiDidChooseAddress @"HDNotiDidChooseAddress"

#define HDWillFreshFriend   @"HDWillFreshFriend"
#define HDDidFreshFriend   @"HDDidFreshFriend"
#define HDDidFailFreshFriend   @"HDDidFailFreshFriend"

#define HDNotiShouldFreshPostSection @"HDNotiShouldFreshPostSection"
#define HDNotiShouldFreshHomePage @"HDNotiShouldFreshHomePage"

#define HDNotiLoginSuccess        @"LoginSuccess"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define PageSize 15

//版本号
#define HDAPPVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define HDAPPVersionBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

//判空宏

#define HDArrIsEmptyOrNil(_arr_) (!_arr_||[_arr_ hd_arrIsEmpty])
#define HDStrIsEmptyOrNil(_str_) (!_str_||[_str_ isEmpty])

//常用变量
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kHigher_iOS_6_1 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define kHigher_iOS_6_1_DIS(_X_) ([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue] * _X_)
#define kNotHigher_iOS_6_1_DIS(_X_) (-([[NSNumber numberWithBool:kHigher_iOS_6_1] intValue]-1) * _X_)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kPaddingLeftWidth 15.0
#define kLoginPaddingLeftWidth 18.0
#define kMySegmentControl_Height 44.0
#define kMySegmentControlIcon_Height 70.0

#define  kBackButtonFontSize 16
#define  kNavTitleFontSize 19
#define  kBadgeTipStr @"badgeTip"

#define kColorTableBG [UIColor colorWithHexString:@"0xfafafa"]

#define kColor999 [UIColor colorWithHexString:@"0x999999"]
#define kColorTableBG [UIColor colorWithHexString:@"0xfafafa"]
#define kColorTableSectionBg [UIColor colorWithHexString:@"0xe5e5e5"]

#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))

#define kPlaceholderMonkeyRoundWidth(_width_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_monkey_round_%.0f", _width_]]
#define kPlaceholderMonkeyRoundView(_view_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_monkey_round_%.0f", CGRectGetWidth(_view_.frame)]]

#define kPlaceholderCodingSquareWidth(_width_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_coding_square_%.0f", _width_]]
#define kPlaceholderCodingSquareView(_view_) [UIImage imageNamed:[NSString stringWithFormat:@"placeholder_coding_square_%.0f", CGRectGetWidth(_view_.frame)]]

#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

//链接颜色
#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x3bbd79"].CGColor}
#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithHexString:@"0x1b9d59"] CGColor]}

//单例宏
#define HDSingletonH(className)   +(instancetype)shared##className;

#define HDSingletonM(className) \
static id instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
} \
+ (instancetype)shared##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return instance; \
}


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

#define HDPageSize 15

#define kPaddingLeftWidth 15.0

//网络默认请求结果判定

#define HDResultData ((result[@"data"])?(result[@"data"]):@"HDRequestSuccess")
#define HDResultMsg (result[@"msg"])
#define HDRequestRJudge (!error&&[result[@"code"] isEqual:@200])
#define HDLocalRequestRJudge (!error&&result)

#define HDDefaultImageB [UIImage imageNamed:@"DefaultImageViewPlaceHolderB"]
#define HDDefaultImageM [UIImage imageNamed:@"DefaultImageViewPlaceHolderM"]
//defualtSpecial
#define HDDefaultImageS [UIImage imageNamed:@"defualtSpecial"]
//系统活动消息的默认图片banner
#define HDDefaultImageA [UIImage imageNamed:@"systemDefualtBanner"]

#define HDDefaultAvatar [HDImageManager HDGetRandomDefaultAvatarImage]
#define HDDefaultImagec [UIImage imageNamed:@"userimage"]

#define TEMP_WIDTH 375.0
#define RATIO SCREEN_WIDTH/TEMP_WIDTH

#define GET(v) GETPXVALUE(v*RATIO)
#define GET_FONT(v) GETPXVALUE(v*RATIO)
#define GETPXVALUE(v) ceil((v)*SCREEN_SCALE)/SCREEN_SCALE

#define THEME_COLOR COLOR_RGB(255, 154, 160, 1)
#define STRING_COLOR COLOR_RGB(255, 0, 104, 1)
#define VIEW_COLOR COLOR_RGB(235, 235, 235, 1)
#define HDLeftBtnColor [UIColor colorWithHexString:@"4A4A4A"]
#define HDTextColorWithCA [UIColor colorWithHexString:@"CACACA"]
#define HDColorWithDC [UIColor colorWithHexString:@"DCDCDC"]
#define HDColorWith79 [UIColor colorWithHexString:@"797979"]

//字体
#define MAINFontRegular  @"PingFangSC-Regular"
#define MAINFontMedium  @"PingFangSC-Medium"
//系统默认字体
#define HDFontSystemR(_size_) [UIFont systemFontOfSize:_size_]
#define HDFontSystemB(_size_) [UIFont boldSystemFontOfSize:_size_]

#define MAINCOLOR @"FF9AA0"
//价格颜色
#define PriceColor [UIColor colorWithHexString:@"FF5E39"]
//背景颜色
#define MainBackgroundColor [UIColor colorWithHexString:@"EBEBEB"]
//主色调
#define MainThemeColor [UIColor colorWithHexString:@"FF9AA0"]
#define MainThemeColorWithAlpha(_alPha_) [UIColor colorWithHexString:@"FF9AA0" andAlpha:_alPha_]

#define PresentNavBGRColor [UIColor colorWithHexString:@"FAFAFA"]

#define REPORT_ARR @[@"非法信息",@"垃圾广告",@"疑似欺诈",@"人身攻击",@"泄露隐私",@"黄色信息"]
#define ReportPeople_ARR @[@"涉嫌诈骗",@"散播黄赌毒非法信息",@"信息虚假",@"广告骚扰",@"侮辱诋毁"]

// 细字体
#define Font(F)                 [UIFont systemFontOfSize:(F)]
// 粗字体
#define boldFont(F)             [UIFont boldSystemFontOfSize:(F)]

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define COLOR_RGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define COLOR_W(W, A) [UIColor colorWithWhite:W/255.0 alpha:A]

#define INTSTR(v) [NSString stringWithFormat:@"%d", v]
#define FLOATSTR(f, v) [NSString stringWithFormat:f, v]
#define IMAGENAMED(p) [UIImage imageNamed:p]

#define ISIOS8ORLATER [[[UIDevice currentDevice] systemVersion] floatValue]>=8
#define ISIOS9ORLATER [[[UIDevice currentDevice] systemVersion] floatValue]>=9



#define CBBeginBackgroundTask() \
UIBackgroundTaskIdentifier taskID = UIBackgroundTaskInvalid; \
taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{ \
[[UIApplication sharedApplication] endBackgroundTask:taskID]; }];

#define CBEndBackgroundTask() \
[[UIApplication sharedApplication] endBackgroundTask:taskID];

#else

#define CBBeginBackgroundTask()
#define CBEndBackgroundTask()

#endif


