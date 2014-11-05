//
//  ProductInfoViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  商品（参数）详细介绍界面

#import <UIKit/UIKit.h>

@interface ProductInfoViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webview;
@property (nonatomic, copy) NSString *productUrl;
@property (nonatomic, copy) NSString *htmlStr;  // html content

@end
