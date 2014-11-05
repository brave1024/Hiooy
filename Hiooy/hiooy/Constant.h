//
//  Constant.h
//  GroupContacts
//
//  Created by Xia Zhiyong on 13-7-3.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

/*
测试账号
13661512157
65131874
372551482@qq.com
¥ 
*/



// 接口地址
#pragma mark - Service Url

// 接口请求地址
#define kBaseUrl @"http://linux.hiooy.com/ecstore/index.php/wap"
// 支付宝支付之回调url
#define kNotifyUrl @"http://linux.hiooy.com/ecstore/index.php/openapi/ectools_payment/parse/wap/wap_payment_plugin_kalipay/callback/"


// 支付宝支付相关
#pragma mark - AliPay

#define AliPartner @"2088411106729982"
#define AliSeller @"gioloe@live.cn"
#define AliMD5Key @"r8vwiem5s5rhsr3ilat82lqbsm7vaeli"
#define AliRsaPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKgApTfib1VEdMeoh1A3K5ch+w2lYguIU/L6jiR/efr/k0MPfeYlP7ySpGQ+bTieTFS19UNv/81HFi8s/0FQsTWQ6uWsbNO6xvJoV/gbUnphvHo6A42QRWzphp0npNRozWViMeY3wcyLeYwIIkSTedIUjQexgUOVkdaoow1arwCRAgMBAAECgYAgmi91zt1oIKbA8DWCHZK5+4Aqv8NtFYGlD3ZyIsLbMKm1Q9ZcyTG7OIHqairr59xMPBtigOOVRIxLj2HhnPUmbYFXsoIE2yvdAL4EaQVnvtZDPNA2rpYHVpq3jTlmeCwnmD4HRkGOr6s0MSBuZKoEazUq4qB0Li6MQaaugEPEWQJBAM+rp0TdiPAXQIVpv8lUySDNsQ+cVuhckxY9VdrzsKvhswlCysqvAihmCEC+heAkBoS0RBZ/94lm/ZgvyspH89sCQQDPGbL+kqV4Bbj1q5Hp2PY15uTNGK40rVnpyg92in+I2ssEewNYmwtrSoKGMxUxVYglQIwNwN5AXgHC0Gnq0P8DAkBX9h4IdkldYIvstokMjwQOB/Haad8J1sRaZCpsblHDy/qYjpj01sH0OJuASPLNqJS2OuCoIxXHNj9t6bhci7OHAkAKwb72Ug+eKE3vFLZDey1up0uDC6Egw1BEQGaFNbRiG1soJGuMEqGJNRmKduTG5zZnGO8tV7MzjK5yu/iEZc6ZAkEAySiS3DGcTRJ+fa7SDNZbYRw4gQCy+eHk9+nIuSU1B1vCHreL4A0xXWxLVtwUXLQfM001ML02JxI5XjWU5FG+MQ=="
#define AliRsaPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


// 银联支付相关
#pragma mark - UnionPay



// 未使用...~!@
#pragma mark - Network Data

#define combine(x, y) [x stringByAppendingString:y]

// 服务器交互数据格式
#define kSendData @"{\"body\":{body},\"head\":{head},\"mac\":{mac}}"
#define kSendHeader @"{\"method\":\"112003\",\"serialNumber\":\"12032114314473700001\",\"version\":\"1\",\"sysVersion\":{sysVersion},\"imei\":{imei},\"terminalstate\":{terminalstate}}"

// terminalstate = 10 用户版appstore(个人)，11 用户版inhouse(企业)，12 商户版appstore(个人)，13 商户版inhouse(企业)
#ifdef INHOUSE
// 企业版
#define kTerminalState @"11"
#else
// 普通版
#define kTerminalState @"10"
#endif


// APP基本信息
#pragma mark - App Info

// BundleShortVersionString为公开版本号:1.0.2
// BundleVersion为内部版本号:1.0.2.8
#define kClientVersionShort [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kClientVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// App Store
#define AppID   @"768062673"
#define AppUrl  @"http://itunes.apple.com/lookup?id=768062673" //@"http://itunes.apple.com/app/id681089823"
#define AppDownload @"http://itunes.apple.com/app/id768062673"
#define AppComment combine(@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=", AppID)

#define AppScheme @"hiooy4ehighsun"


// 当前IOS版本
#ifndef __CUR_IOS_VERSION
#define __CUR_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue] * 10000)
#endif

// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAppWindow (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


// 本地路径名
#pragma mark - Local Directory

// 本地数据库名
#define kDatabase @"hiooy"
// 本地临时文件缓存路径
#define TEMP_FOLDER_NAME @"tmp"
// 本地图片缓存路径
#define IMAGE_FOLDER_NAME @"images"


// 第三方平台key
#pragma mark - App Key

// 友盟Appkey
#define UMENG_APPKEY @"532d03aa56240b2cf5130a23"    // xia's meng:5271aa7256240b90580df5c1
// 渠道号
#define CHANNEL @"App Store"
// 微信appid
#define WECHAT_APPID @"wxfd8ab1a4500edd3a"  // 待修改

// 新浪key...<不在工程中设置,在友盟中设置>
//#define SINA_KEY @"2203152200"
//#define SINA_SECRET @"453f6c9d25010de1fec4b9e3490c0159"

/*
 // 天涯海角<微信平台应用>
 AppID：wxfd8ab1a4500edd3a
 AppSecret：1dbdbe2edc5986c0309bf4fdbb575f3e
 */


#pragma mark - For Debug

// TRACE CONFIG
#define LOGGING_ENABLED 1
#define LOGGING_INCLUDE_CODE_LOCATION 1
#define LOGGING_LEVEL_INFO 1
// FILE LOGGING
#define LOGGING_TO_FILE
#undef LOGGING_TO_FILE

#ifdef DEBUG
// 开发时使用，发版本时应去掉

#endif


// 文字长度限制
#pragma mark - Limitation Of Length

// 输入框字符最大长度
// 姓名
#define NameMaxLength 10
// 账号
#define AccountMaxLength 20
// 手机号
#define MobileMaxLength 11
// 邮箱号
#define EmailMaxLength 30
// 邮编
#define ZipcodeMaxLength 6
// 密码
#define PwdMaxLength 20
// 验证码
#define VerifyMaxLength 6
// 密码最小长度
#define PwdMinLength 6
// 文字输入长度
#define kMaxLength 140
// 地址输入长度
#define AddressMaxLengt 50
// 座机号
#define TelMaxLength 15


// 通知
#pragma mark - 通知名

// 刷新个人中心
#define kRefreshUserCenter @"refreshUserCenter"
// 刷新收货地址列表
#define kRefreshAddressList @"refreshAddressList"
// 刷新待评价商品列表
#define kRefreshProductComment @"refreshProductComment"
// 新注册用户添加地址成功后,提交订单界面需实时更新地址信息
#define kShowUserNewAddress @"showUserNewAddress"
// 支付成功后返回到个人中心
#define kBackToUserCenter @"backToUserCenter"
// 秒杀之时间计数
#define kTimePass @"timePass"

// app进入后台时的通知名
#define kAppEnterBackground @"AppEnterBackground"
// app从后台激活的通知名
#define kAppBecomeActive @"AppBecomeActive"
// app断开网络通知
#define kAppLoseNetwork @"AppLoseNetwork"
// app获取网络通知
#define kAppGetNetwork @"AppGetNetwork"
// 获取到推送的Id
#define kPushIdsGot @"PushIdsGot"
// 注册远程通知失败
#define kRegNoticeFailed @"RegNoticeFailed"
// 登录成功后的通知
#define kLoginSuccess @"LoginSuccess"
// 隐藏购物车界面的键盘的通知
#define kHideKeyboardInCart @"hideKeyboardInCart"
// 隐藏购物车界面中其它cell上的键盘
#define kHideKeyboardInOtherCells @"hideKeyboardInOtherCells"


// 本地存储用到的key
#pragma mark - UserDefaults

// 判断是否为第一次启动(用于userdefault,非通知)
#define kIsFirstLaunch @"IsFirstLaunch"
// 设备Id
#define kDeviceToken @"DeviceToken"
// 推送所有id
#define kPushIds @"PushIds"
// 是否需要自动登录，考虑到注销的情况
#define kNeedAutoLogin @"NeedAutoLogin"
// 用户收货地址列表
#define kUserAddrList @"UserAddrList"
// 用户收货地址列表
#define kDefaultAddr @"DefaultAddr"
// 用户名
#define kUserName @"userName"
// 用户密码
#define kUserPsw @"userPassword"
// 用户账号类型
#define kUserType @"userType"
// 保存全国地区数据的文件名
#define kAreaData @"AreaData"


// 相关提示文字
#pragma mark - Special String

// 分享标题
#define SHARE_TITLE @"海印移动商城"
// 分享内容
#define SHARE_CONTENT @"海印移动商城之分享内容..."
// 产品下载链接
#define APP_DOWNLOAD_URL @"http://www.hiooy.com"

// 相关提示文字
#define kNetworkErrorMsg @"网络不可用,请检查网络设置"
// 加载中
#define kLoading @"加载中..."
// 加载完毕
#define kLoadOver @"数据加载完毕"
// 暂无数据
#define kNoDataReturn @"暂无数据"
// 获取数据失败
#define kGetDataFailed @"获取数据失败,请稍后重试"

// 默认图片名
#define kImageNameDefault @"imgDefault"


// 
#pragma mark - For Compatibility (兼容)

// 对齐方式
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
#define TextAlignmentLeft   NSTextAlignmentLeft
#define TextAlignmentCenter NSTextAlignmentCenter
#define TextAlignmentRight  NSTextAlignmentRight
#else
#define TextAlignmentLeft   UITextAlignmentLeft
#define TextAlignmentCenter UITextAlignmentCenter
#define TextAlignmentRight  UITextAlignmentRight
#endif
// 文本属性
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define TextAttributeTextColor  NSForegroundColorAttributeName
#define TextAttributeFont       NSFontAttributeName
#else
#define TextAttributeTextColor  UITextAttributeTextColor
#define TextAttributeFont       UITextAttributeFont
#endif
// 获取文本高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define textSizeWithFont(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define textSizeWithFont(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif
// 多行文本获取高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define multilineTextSize(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define multilineTextSize(text, font, maxSize) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize] : CGSizeZero;
#endif

