//
//  AppDelegate.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "SliderViewController.h"
#import "RightViewController.h"
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import "TabBarViewController.h"

#import "MobClick.h"
#import "UMSocial.h"
#import "Reachability.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "RemoteVersionModel.h"
#import "RegisterReqModel.h"
#import "LoginReqModel.h"
#import "AddressItemModel.h"

#import "InterfaceManager.h"

// pay
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"


@interface AppDelegate ()

@property (nonatomic, retain) Reachability *hostReach;
@property (nonatomic, strong) UIButton *btnShader;

//@property (nonatomic, strong) NSTimer *timer;
//@property int rTime;
@end


#define TAG_ALERT 100
#define LEFT_WINDOW_WIDTH 215
NetworkStatus g_reachableState;


@implementation AppDelegate

- (BOOL)openURL:(NSURL*)url
{
    //FourthWebViewController *bvc = [[FourthWebViewController alloc] initWithUrls:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
     UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
     [tabBar setSelectedIndex:2];
     CGRect rect = [[UIScreen mainScreen] bounds];
     rect.size.width = LEFT_WINDOW_WIDTH;
     self.leftWindow = [[UIWindow alloc] initWithFrame:rect];
     
     LeftViewController *leftVC = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
     UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:leftVC];
     
     [self.leftWindow setRootViewController:navVC];
     [self.leftWindow makeKeyAndVisible];
     
     rect = [[UIScreen mainScreen] bounds];
     _btnShader = [UIButton buttonWithType:UIButtonTypeCustom];
     [_btnShader setFrame:rect];
     [_btnShader setAlpha:0.0];
     [_btnShader setHidden:YES];
     [_btnShader setBackgroundColor:[UIColor grayColor]];
     [_btnShader addTarget:self action:@selector(showMainView) forControlEvents:UIControlEventTouchDown];
     [self.window addSubview:_btnShader];
     
     rect.origin.x = LEFT_WINDOW_WIDTH;
     */
    
    // 使用storyboard时，不再初始化当前window
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 消除界面切换时,导航栏背景色变暗的问题
    UIView *view = [[UIView alloc] initWithFrame:self.window.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 100;
    [self.window addSubview:view];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self.tabVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    //[self.window setRootViewController:tabVC];
    
    NavigationViewController *NavVC = [[NavigationViewController alloc] initWithRootViewController:self.tabVC];
    [self.window setRootViewController:NavVC];
    
    self.willSelectedIndex = 0;
    self.currentSelectedIndex = 0;
    
    /*
    NavigationViewController *centerNavVC = [[NavigationViewController alloc] initWithRootViewController:tabVC];
//    TabBarViewController *tabVC = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
    LeftViewController *leftVC = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    RightViewController *rightVC = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    NavigationViewController *rightNavVC = [[NavigationViewController alloc] initWithRootViewController:rightVC];
    SliderViewController *sliderVC = [[SliderViewController alloc] initWithViewControllers:@[leftVC, centerNavVC, rightNavVC]];
    [self.window setRootViewController:sliderVC];
//    [self.window setFrame:rect];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController *tabBar = (UITabBarController *)[storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
    */
    
    [self.window makeKeyAndVisible];
    
    /*************************************************************/
    
    // AFN设置
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 开启网络监听
    g_reachableState = NotReachable;
    _hostReach = [Reachability reachabilityForInternetConnection];
    [_hostReach startNotifier];  // 开始监听,会启动一个run loop
    g_reachableState = [_hostReach currentReachabilityStatus];
    
    // 友盟统计＋分享
    [self umengTrackAndShare];
    
    // 请求广告
    [self requestAds];
    
    // 自动登录
    [self autoLogin];
    
    // XML Test
    //[self XMLTest];
    
    // HTTP Test
    //[self webServiceTest];
    
    return YES;
}

- (void)requestAds
{
//    [InterfaceManager getAdsInHomepage:^(BOOL isSucceed, NSString *message, id data) {
//        if (isSucceed)
//        {
//            NSLog(@"获取广告图片成功");
//            NSDictionary *dic = [(NSDictionary *)data objectForKey:@"data"];
//            NSError *error = nil;
//            
//        }
//        else
//        {
//            NSLog(@"%@", message);
//        }
//    }];
}

- (void)autoLogin
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDef objectForKey:kUserName];
    NSString *password = [userDef objectForKey:kUserPsw];
    NSString *type = [userDef objectForKey:kUserType];
    if (name == nil || password == nil || type == nil)
    {
        NSLog(@"未有用户成功登录过...<无账号和密码记录>");
    }
    else
    {
        UserManager *userManager = [UserManager shareInstant];
        [userManager userLogin:name withPassword:password andType:type completion:^(BOOL isSucceed, NSString *message) {
            if (isSucceed)
            {
                NSLog(@"登录成功");
            }
            else
            {
                NSLog(@"登录失败:%@", message);
            }
        }];
    }
}

//- (void)beginTimePassAction
//{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
//}
//
//- (void)timeChanged
//{
//    self.rTime++;
//    NSLog(@"...<<<%d>>>...", self.rTime);
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTimePass object:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.rTime] forKey:@"time"]];
//}
//
//- (void)stopTimePass
//{
//    self.rTime = 0;
//    if (self.timer != nil)
//    {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}


- (void)XMLTest
{
    [XMLHelper xmlParserTest];
    [XMLHelper createXMLTest];
    
    RegisterReqModel *registerData = [[RegisterReqModel alloc] init];
    registerData.license = @"agree";
    registerData.login_name = @"kingkong1024";
    registerData.login_password = @"1024xzy";
    registerData.psw_confirm = @"1024xzy";
    registerData.mobile = @"18507103285";
    registerData.email = @"brave1024@gmail.com";
    registerData.name = @"夏志勇";
    [XMLHelper getRegisterXML:registerData];
    
    LoginReqModel *loginData = [[LoginReqModel alloc] init];
    loginData.uname = @"kingkong1024";
    loginData.password = @"1024xzy";
    [XMLHelper getLoginXML:loginData];
    
    AddressItemModel *addressData = [[AddressItemModel alloc] init];
    addressData.name = @"夏志勇";
    addressData.area_id = @"mainland:广东/广州市/东山区:425";
    addressData.addr = @"广东广州市东山区123号";
    addressData.zipcode = @"200082";
    addressData.telephone = @"110";
    addressData.mobile = @"18507103285";
    addressData.is_default = @"1";
    [XMLHelper getAddressXML:addressData];
}

- (void)webServiceTest
{
    // 13005145815 058717
    // zhxyxyz123 65131874
    // cookov 123456
//    [InterfaceManager userLogin:@"cookov" withPassword:@"123456" completion:^(BOOL isSucceed, NSString *message, id data) {
//        if (isSucceed)
//        {
//            NSLog(@"login success:%@", message);
//            //[NSThread sleepForTimeInterval:5];
//        }
//        else
//        {
//            NSLog(@"login failed:%@", message);
//        }
//    }];
    
//    [InterfaceManager userRegister:@"cookov" withPassword:@"123456" andEmail:@"110381582@qq.com" completion:^(BOOL isSucceed, NSString *message, id data) {
//        if (isSucceed)
//        {
//            NSLog(@"register success:%@", message);
//        }
//        else
//        {
//            NSLog(@"register failed:%@", message);
//        }
//    }];
    
    //sleep(5);
    //[NSThread sleepForTimeInterval:5];
    
    // 修改密码
//    [InterfaceManager userChangePassword:@"000000" withNewPassword:@"123456" completion:^(BOOL isSucceed, NSString *message, id data) {
//        if (isSucceed)
//        {
//            NSLog(@"change password success:%@", message);
//        }
//        else
//        {
//            NSLog(@"change password failed:%@", message);
//        }
//    }];
    
}

- (void)showLeftView
{
    [self.window bringSubviewToFront:_btnShader];
    [_btnShader setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        rect.origin.x = LEFT_WINDOW_WIDTH;
        [self.window setFrame:rect];
        [_btnShader setAlpha:0.6];
    }];
}

- (void)showMainView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        [self.window setFrame:rect];
        [_btnShader setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_btnShader setHidden:YES];
    }];
}

- (UIViewController *)getRootViewController
{
//    SliderViewController *theSlideVC = (SliderViewController *)self.window.rootViewController;
//    return theSlideVC;
    NavigationViewController *navVC = (NavigationViewController *)self.window.rootViewController;
    return navVC;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - WEIXIN & Pay

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
    NSString *urlStr = [url absoluteString];
    NSLog(@"handleOpenURL url:%@", urlStr);
    
    if ([urlStr hasPrefix:@"wx"])
    {
        // 微信分享
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    else
    {
        // 支付宝
        [self parse:url application:application];
        return YES;
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
    NSString *urlStr = [url absoluteString];
    NSLog(@"openURL url:%@", urlStr);
    
    if ([urlStr hasPrefix:@"wx"])
    {
        // 微信分享
        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    else
    {
        // 支付宝
        [self parse:url application:application];
        return YES;
    }
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    NSLog(@"交易结果处理");
    
    //结果处理
    AlixPayResult *result = [self handleOpenURL:url];
    NSLog(@"%@", result);
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSLog(@"交易成功");
            
            //NSString *key = @"签约帐户后获取到的支付宝公钥";
            NSString *key = AlipayPubKey;
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);

			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"验证签名成功，交易结果无篡改");
                PGToast *toast = [PGToast makeToast:@"交易成功"];
                [toast show];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBackToUserCenter object:nil];
			}
            else
            {
                NSLog(@"验证签名失败，交易结果已被篡改...~!@");
            }
        }
        else
        {
            //交易失败
            NSLog(@"交易失败");
        }
    }
    else
    {
        //失败
        NSLog(@"失败");
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult *result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}


#pragma mark - Share

- (void)umengTrackAndShare
{
    // 统计分析
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:CHANNEL];
    // reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    // channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    /*****************************************************************************/
    
    // 分享
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    // 微信分享设置...
    //设置微信AppId，url地址(点击图文消息的url设置为nil,将默认使用友盟的网址)即app下载链接或app相关网址
    [UMSocialConfig setWXAppId:WECHAT_APPID url:APP_DOWNLOAD_URL];
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    //UMSocialWXMessageTypeImage为纯图片类型,即只分享一张图片,无链接,点击后下载图片而不跳转
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = SHARE_TITLE;
    [UMSocialData defaultData].extConfig.wxDescription = SHARE_CONTENT;
    
    // 新浪分享设置...
    //打开新浪微博的SSO(免登录)开关
    [UMSocialConfig setSupportSinaSSO:NO];
    //UMSocialSnsPlatform *sinaPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    // 设置分享完成后的toast显示方式
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
    //[UMSocialConfig setShouldShareSynchronous:YES];
    
    // 处理分享错误
    [UMSocialData openLog:YES];
}


#pragma mark - VersionUpdate

// 检查版本更新 for APP Store
- (void)checkVersionForAppstore {
    // 请求远程版本
    NSLog(@"版本检测 for APP Store");
    NSString *URL = AppUrl;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSString *results = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
         RemoteVersionModel *remoteVersion = [[RemoteVersionModel alloc] initWithString:results error:nil];
         NSArray *infoArray = remoteVersion.results;
         if ([infoArray count])
         {
             NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
             NSString *lastVersion = [releaseInfo objectForKey:@"version"];
             LogInfo(@" curVersion : %@ \n newVersion : %@", kClientVersion, lastVersion);
             if ([lastVersion isNewThanVersion:kClientVersion])
             {
                 _haveNewVersion = YES;
                 //[[NSNotificationCenter defaultCenter] postNotificationName:kCheckVersion object:nil];
                 NSString *titleStr = [NSString stringWithFormat:@"发现新版本 (%@)", [releaseInfo objectForKey:@"version"]];
                 NSString *contentStr = [releaseInfo objectForKey:@"releaseNotes"];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:contentStr delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil];
                 alert.tag = TAG_ALERT;
                 [alert show];
             }
         }
     }];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TAG_ALERT)
    {
        if (buttonIndex == 1)
        {
            // 跳转到app store
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppDownload]];
        }
        else
        {
            NSLog(@"已是最新版本");
        }
    }
}


@end
