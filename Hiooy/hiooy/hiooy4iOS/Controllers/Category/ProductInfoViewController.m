//
//  ProductInfoViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductInfoViewController.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController

static NSString *baseUrl = @"http://linux.hiooy.com";

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
    
    self.navigationItem.title = @"详细介绍";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navController showBackButtonWith:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)241/255 blue:(CGFloat)241/255 alpha:1];
    
//    NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", baseUrl, self.productUrl];
//    NSLog(@"url:%@", fullUrlStr);
//    NSURL *url = [NSURL URLWithString:fullUrlStr];
//    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    if (self.htmlStr != nil && self.productUrl == nil)
    {
        // 直接加载html内容
        NSLog(@"%@", self.htmlStr);
        [self.webview loadHTMLString:self.htmlStr baseURL:nil];
    }
    else
    {
        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", baseUrl, self.productUrl];
        NSLog(@"url:%@", fullUrlStr);
        NSURL *url = [NSURL URLWithString:fullUrlStr];
        [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    self.webview.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
