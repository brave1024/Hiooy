//
//  WebViewController.h
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//  web界面

#import <UIKit/UIKit.h>
#import "WebMutualManager.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, WebActionDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *navTitle;
//@property (nonatomic, strong) NSString *activeId;
//@property (nonatomic, strong) UIButton *btnShare;

@end
