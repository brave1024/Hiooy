//
//  WebViewController.m
//  Xia
//
//  Created by Xia Zhiyong on 13-9-24.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "WebViewController.h"
#import "BackNavItem.h"

@implementation UIApplication(Browser)

-(BOOL)openURL:(NSURL *)url forceOpenInSafari:(BOOL)forceOpenInSafari
{
    if(forceOpenInSafari)
    {
        // We're overriding our app trying to open this URL, so we'll let UIApplication federate this request back out
        //  through the normal channels. The return value states whether or not they were able to open the URL.
        return [self openURL:url];
    }
    
    //
    // Otherwise, we'll see if it is a request that we should let our app open.
    
    BOOL couldWeOpenUrl = NO;
    
    NSString* scheme = [url.scheme lowercaseString];
    if([scheme compare:@"http"] == NSOrderedSame
       || [scheme compare:@"https"] == NSOrderedSame)
    {
        // TODO - Here you might also want to check for other conditions where you do not want your app opening URLs (e.g.
        //  Facebook authentication requests, OAUTH requests, etc)
        
        // TODO - Update the cast below with the name of your AppDelegate
        // Let's call the method you wrote on your AppDelegate to actually open the BrowserViewController
        couldWeOpenUrl = [(id<BrowserViewDelegate>)self.delegate openURL:url];
    }
    
    if(!couldWeOpenUrl)
    {
        return [self openURL:url];
    }
    else
    {
        return YES;
    }
}

@end


@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView;
@synthesize url;
@synthesize toolbar;
@synthesize forwardButton;
@synthesize backButton;
@synthesize stopButton;
@synthesize reloadButton;
@synthesize actionButton;
@synthesize navBar;


/**********************************************************************************************************************/
#pragma mark - UIActionSheet Delegate
// 用safari打开
- (void)actionSheet:(UIActionSheet *)uias clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // user pressed "Cancel"
    if(buttonIndex == [uias cancelButtonIndex]) return;
    
    // user pressed "Open in Safari"
    if([[uias buttonTitleAtIndex:buttonIndex] compare:ACTION_OPEN_IN_SAFARI] == NSOrderedSame)
    {
        [[UIApplication sharedApplication] openURL:self.url forceOpenInSafari:YES];
    }
    
    // TODO add your own actions here, like email the URL.
}


/**********************************************************************************************************************/
#pragma mark - Object lifecycle
// 控件初始化...不再使用
- (id)initWithUrls:(NSURL*)u
{
    self = [self initWithNibName:@"FourthWebViewController" bundle:nil];
    if(self)
    {
        self.webView.delegate = self;
        self.url = u;
        
        // 判断系统版本
        float systemVer = [[UIDevice currentDevice].systemVersion floatValue];
        NSLog(@"system version:%f", systemVer);
        if (systemVer < 7.0) {
            self.webView.frame = CGRectMake(0, 44, 320, kScreenHeight-64-44);
        }
        self.webView.scalesPageToFit = YES;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:PNG_BUTTON_FORWARD]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(forwardButtonPressed:)];
        
        
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:PNG_BUTTON_BACK]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(backButtonPressed:)];
        
        self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                        target:self
                                                                        action:@selector(stopReloadButtonPressed:)];
        
        self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                          target:self
                                                                          action:@selector(stopReloadButtonPressed:)];
        
        self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                          target:self
                                                                          action:@selector(actionButtonPressed:)];
		
        // Hide tab bars / toolbars etc
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

// 控件初始化
- (void)initAction {
    
    // 判断系统版本
    float systemVer = [[UIDevice currentDevice].systemVersion floatValue];
    NSLog(@"system version:%f", systemVer);
    if (systemVer < 7.0) {
        self.webView.frame = CGRectMake(0, 44, 320, kScreenHeight-64-44);
    }
    self.webView.scalesPageToFit = YES;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:PNG_BUTTON_FORWARD]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(forwardButtonPressed:)];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:PNG_BUTTON_BACK]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(backButtonPressed:)];
    
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                    target:self
                                                                    action:@selector(stopReloadButtonPressed:)];
    
    self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                      target:self
                                                                      action:@selector(stopReloadButtonPressed:)];
    
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                      target:self
                                                                      action:@selector(actionButtonPressed:)];
    
    // Hide tab bars / toolbars etc
    self.hidesBottomBarWhenPushed = YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**********************************************************************************************************************/
#pragma mark - View lifecycle
// 更新界面下方的工具栏
- (void)updateToolbar
{
    // toolbar
    self.forwardButton.enabled = [self.webView canGoForward];
    self.backButton.enabled = [self.webView canGoBack];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *toolbarButtons = [[NSMutableArray alloc] initWithObjects:self.backButton, flexibleSpace, self.forwardButton,
                                      flexibleSpace, self.reloadButton, flexibleSpace, self.actionButton, nil];
    
    if([activityIndicator isAnimating]) [toolbarButtons replaceObjectAtIndex:4 withObject:self.stopButton];
    
    [self.toolbar setItems:toolbarButtons animated:YES];
    
    // page title
    NSString *pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(pageTitle)
    {
        [[self.navBar topItem] setTitle:pageTitle];
        self.navigationItem.title = pageTitle;
    }
    
    // If there is a navigation controller, take up the same style for the toolbar.
    if (self.navigationController) {
        self.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        // iOS5 specific part
        if ([self.navigationController.navigationBar respondsToSelector:@selector(backgroundImageForBarMetrics:)]) {
            if ([self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]) {
                [self.toolbar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]
                              forToolbarPosition:UIToolbarPositionAny
                                      barMetrics:UIBarMetricsDefault];
                
            }
            
            if ([self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone]) {
                [self.toolbar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone]
                              forToolbarPosition:UIToolbarPositionAny
                                      barMetrics:UIBarMetricsLandscapePhone];
                
            }
        }
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.title = @"热门景点";
    //self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)228/255 green:(CGFloat)236/255 blue:(CGFloat)244/255 alpha:1];
    
    // 设置返回键
//    BackNavItem *backNav = [[BackNavItem alloc] initWithTitle:@"返回"
//                                                         type:UIBackNavWhite
//                                                       target:self
//                                                       action:@selector(backAction)];
//    [self.navigationItem setLeftBarButtonItem:backNav animated:YES];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 6, 48, 32);
    [btnBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    /****************************************************************************/
    
    // 增加自定义的导航栏
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    // 返回
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 7, 52, 30);
//    //[btnBack setTitle:@"返回" forState:UIControlStateNormal];
//    [btnBack.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [btnBack setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    //[btnBack setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
//    [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    [navItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [navItem setRightBarButtonItem:rightItem];
    [navBar pushNavigationItem:navItem animated:NO];
    
    [self initAction];
    
    // add by xzy
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = rightItem1;
    
    if (self.htmlStr != nil && self.url == nil)
    {
        // 直接加载html内容
        NSLog(@"%@", htmlStr);
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }
    else
    {
        // 加载传递过来的url
        NSLog(@"url:%@", self.url);
        //[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
        
        NSString *post = [self.post toJSONString];
        NSLog(@"post string:%@", post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:self.url];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        [self.webView loadRequest:request];
    }
    
    [self updateToolbar];
}

- (void)viewDidUnload
{
    [[self navigationItem] setRightBarButtonItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight
            || interfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


/**********************************************************************************************************************/
#pragma mark - User Interaction

- (void)backAction {
    
    if([activityIndicator isAnimating])
    {
        [self.webView stopLoading];
        [activityIndicator stopAnimating];
    }

    // 刷新个人中心数据
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserCenter object:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
}

- (void)backButtonPressed:(id)sender
{
    if([self.webView canGoBack]) [self.webView goBack];
}

- (void)forwardButtonPressed:(id)sender
{
    if([self.webView canGoForward]) [self.webView goForward];
}

- (void)stopReloadButtonPressed:(id)sender
{
    if([activityIndicator isAnimating])
    {
        [self.webView stopLoading];
        [activityIndicator stopAnimating];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
    
    [self updateToolbar];
}

- (void)actionButtonPressed:(id)sender
{
    UIActionSheet *uias = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:ACTION_CANCEL
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:ACTION_OPEN_IN_SAFARI, nil];
    
    [uias showInView:self.view];
}


/**********************************************************************************************************************/
#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    [self updateToolbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(activityIndicator) [activityIndicator stopAnimating];
    [self updateToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateToolbar];
}


@end

