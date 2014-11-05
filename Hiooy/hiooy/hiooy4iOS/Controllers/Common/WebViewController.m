//
//  WebViewController.m
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"";
    
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        [self.navController showBackButtonWith:self andAction:@selector(back)];
        [self.navigationController setNavigationBarHidden:NO];
        if (_navTitle)
        {
            // 设置wap页面标题
            self.navigationItem.title = _navTitle;
        }
    }
    
    [_webView setBackgroundColor:[UIColor colorFromHexRGB:@"d1d1d1"]];
//    _webUrl = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web/recommend.html"];
//    _webUrl = @"http://192.168.11.128/topicapp/apply.html";
    // 加载网页文件
    
    if ([_webUrl hasPrefix:@"http"]) {
        // 网络url
        NSURLRequest *request = [NSURLRequest requestWithURL:[self assembleUrl]];
        //[_webView.scrollView setScrollEnabled:NO];
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
        [_webView loadRequest:request];
    } else {
        // 本地url
        NSString *content = [NSString stringWithContentsOfFile:_webUrl encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:content baseURL:[self assembleUrl]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Public

- (void)configWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicForWeb = (NSDictionary *)data;
        NSString *navTitle = [dicForWeb objectForKey:@"navTitle"];
        NSString *webUrl = [dicForWeb objectForKey:@"webUrl"];
        if (navTitle) {
            _navTitle = navTitle;
        }
        if (webUrl) {
            _webUrl = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"] stringByAppendingPathComponent:webUrl];
        }
    }
}


#pragma mark - Action

- (void)back
{
    LogTrace(@" {Button Click} ");
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


#pragma mark - Private

- (NSURL *)assembleUrl
{
    NSMutableString *requestUrl = [NSMutableString stringWithString:_webUrl];
    LogTrace(@"%@", requestUrl);
    NSNumber *userId = [[UserManager shareInstant] getMemberId];
    if (userId == nil) {
        userId = [NSNumber numberWithInt:0];
    }
    NSNumber *isLogin = [NSNumber numberWithBool:[[UserManager shareInstant] isLogin]];
    NSString *parameterStr = [NSString stringWithFormat:@"userId=%@&isLogin=%d", userId, [isLogin intValue]];
    if ([requestUrl rangeOfString:@"?"].location > 0) {
        [requestUrl appendString:@"?"];
    }
    [requestUrl appendString:parameterStr];
    if ([requestUrl hasPrefix:@"http"]) {
        return [NSURL URLWithString:requestUrl];
    } else {
        return [NSURL fileURLWithPath:requestUrl];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = [NSString stringWithFormat:@"webMutual.isPlatformActive=true"];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
     NSURL* url = [request URL];
    if ([[url scheme] isEqualToString:@"kkmy"]) {
        NSLog(@"%@", [url resourceSpecifier]);
        NSString *requestId = [url resourceSpecifier];
        [[WebMutualManager shareInstant] handleThisRequest:requestId withDelegate:self];
//        [self performSelectorOnMainThread:@selector(getRequestData:) withObject:requestId waitUntilDone:NO];
        return NO;
    }
    return YES;
}


@end
