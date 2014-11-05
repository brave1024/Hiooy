//
//  WebMutualManager.m
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//  

#include <objc/message.h>
#import "WebMutualManager.h"
#import "WebRequestModel.h"
#import "WebResultModel.h"
#import "AppDelegate.h"

static WebMutualManager *s_webMutualManager = nil;

@interface WebMutualManager ()

@property (nonatomic, strong) NSDictionary *dicActiveActions;

@end

@implementation WebMutualManager

+ (WebMutualManager *)shareInstant
{
    if (s_webMutualManager == nil)
    {
        s_webMutualManager = [[WebMutualManager alloc] init];
        
    }
    return s_webMutualManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"webAction.plist"];
        _dicActiveActions = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        
    }
    return self;
}

- (void)handleThisRequest:(NSString *)requestId withDelegate:(id<WebActionDelegate>)delegate
{
    // 获取请求数据
    NSString *requestData = [self getRequestData:requestId withWebView:delegate.webView];
    if ([requestData length] == 0)
    {
        LogError(@"Cann't get request data with request Id : %@", requestId);
        return;
    }
    // 解析数据
    @try {
        WebRequestModel *webRequest = [[WebRequestModel alloc] initWithString:requestData error:nil];
        switch (webRequest.model)
        {
            case kWebOpenView:
            {
                // 打开一个界面
                NSDictionary *dicModel = [_dicActiveActions objectForKey:@"0"];
                NSDictionary *dicHandler = [dicModel objectForKey:webRequest.handler];
                if (dicHandler == nil) {
                    // 平台未接收该接口
                    WebResultModel *webResult = [[WebResultModel alloc] init];
                    webResult.isSuccess = NO;
                    webResult.callbackId = webRequest.callbackId;
                    webResult.message = @"平台未接收该接口";
                    webResult.data = @"";
                    [self callbackWithResult:webResult andWebView:delegate.webView];
                    return;
                }
                NSString *strDisplayVC = [dicHandler objectForKey:@"displayVC"];
                Class displayVC = NSClassFromString(strDisplayVC);
                UIViewController *aVC = [[displayVC alloc] initWithNibName:strDisplayVC bundle:nil];
                [aVC configWithData:webRequest.jsonData];
                NavigationViewController *aNavVC = [[NavigationViewController alloc] initWithRootViewController:aVC];
//                [[kAppDelegate topViewController] presentViewController:aNavVC animated:YES completion:nil];
                break;
            }
            case kWebFetchData:
            {
                // 从平台层获取数据
                NSDictionary *dicModel = [_dicActiveActions objectForKey:@"1"];
                NSDictionary *dicHandler = [dicModel objectForKey:webRequest.handler];
                if (dicHandler == nil) {
                    // 平台未接收该接口
                    WebResultModel *webResult = [[WebResultModel alloc] init];
                    webResult.isSuccess = NO;
                    webResult.callbackId = webRequest.callbackId;
                    webResult.message = @"平台未接收该接口";
                    webResult.data = @"";
                    [self callbackWithResult:webResult andWebView:delegate.webView];
                    return;
                }
                NSString *handlerClass = [dicHandler objectForKey:@"handlerClass"];
                Class theClass = NSClassFromString(handlerClass);
                NSObject *theUser = [theClass shareInstant];
                SEL selector = NSSelectorFromString([dicHandler objectForKey:@"action"]);
                id dataReceive = objc_msgSend(theUser, selector, webRequest.jsonData);
                NSString *returnString = @"";
                if (dataReceive != nil)
                {
                    // 获取到数据，可立即返回
                    if ([dataReceive isKindOfClass:[NSString class]])
                    {
                        returnString = (NSString *)dataReceive;
                    }
                    else if ([[dataReceive class] isSubclassOfClass:[JSONModel class]])
                    {
                        returnString = [dataReceive toJSONString];
                    }
                    else if ([dataReceive isKindOfClass:[NSDictionary class]])
                    {
                        returnString = [dataReceive convertToJsonString];
                    }
                    WebResultModel *webResult = [[WebResultModel alloc] init];
                    webResult.isSuccess = YES;
                    webResult.callbackId = webRequest.callbackId;
                    webResult.message = @"获取数据成功";
                    webResult.data = returnString;
                    [self callbackWithResult:webResult andWebView:delegate.webView];
                }
                else
                {
                    // 未获取到数据
                    WebResultModel *webResult = [[WebResultModel alloc] init];
                    webResult.isSuccess = NO;
                    webResult.callbackId = webRequest.callbackId;
                    webResult.message = @"获取数据失败";
                    webResult.data = returnString;
                    [self callbackWithResult:webResult andWebView:delegate.webView];
                }
                break;
            }
            case kWebSendData:
                
                break;
            case kWebShowAlert:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:webRequest.jsonData
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case kWebShowToast:
            {
                SliderViewController *aSlideVC =  (SliderViewController *)[kAppDelegate getRootViewController];
                [aSlideVC toast:webRequest.jsonData];
                break;
            }
            case kWebStartLoading:
            {
                SliderViewController *aSlideVC =  (SliderViewController *)[kAppDelegate getRootViewController];
//                [aSlideVC startLoading:webRequest.jsonData];
                break;
            }
            case kWebStopLoading:
            {
                SliderViewController *aSlideVC =  (SliderViewController *)[kAppDelegate getRootViewController];
//                [aSlideVC stopLoading];
                break;
            }
            case kWebCopyText:
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setPersistent:YES];
                pasteboard.string = @"kkmaiyao";
                SliderViewController *aSlideVC =  (SliderViewController *)[kAppDelegate getRootViewController];
                [aSlideVC toast:@"复制成功"];
                break;
            }
            default:
                break;
        } ;
        
    }
    @catch (NSException *exception)
    {
        LogDebug(@"%@", exception);
        return;
    }
    @finally
    {
        
    }
}

- (NSString *)getRequestData:(NSString *)requestId withWebView:(UIWebView *)webView
{
    NSString *js = [NSString stringWithFormat:@"webMutual.getRequestData(\'%@\')", requestId];
    NSString* requestData = [webView stringByEvaluatingJavaScriptFromString:js];
    return requestData;
}

- (void)callbackWithResult:(WebResultModel *)result andWebView:(UIWebView *)webView
{
    NSString *resultStr = [result toJSONString];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *js = [NSString stringWithFormat:@"webMutual.platformCallback(\'%@\')", resultStr];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
