//
//  TabBarViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-20.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "TabBarViewController.h"
#import "MainViewController.h"
#import "ShoppingCartViewController.h"
#import "MoreViewController.h"
#import "MyHiooyViewController.h"
#import "LifeCircleViewController.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

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
    
    _tabBarManager = [[TabBarManager alloc] initWithTabBar:self];
    [self setDelegate:_tabBarManager];
    [self setSelectedIndex:0];
    
    // add by xia zhiyong
    if (__CUR_IOS_VERSION < __IPHONE_7_0)
    {
//        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
//        imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [imgView setImage:[UIImage imageNamed:@"tabbar.png"]];
//        [self.tabBar insertSubview:imgView atIndex:0];
        
        if ([self.tabBar respondsToSelector:@selector(setBackgroundImage:)]) {
            // ios 5 code here
            [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
        }
        else {
            // ios 4 code here
            CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
            UIView *tabbg_view = [[UIView alloc] initWithFrame:frame];
            UIImage *tabbag_image = [UIImage imageNamed:@"tabbar.png"];
            UIColor *tabbg_color = [[UIColor alloc] initWithPatternImage:tabbag_image];
            tabbg_view.backgroundColor = tabbg_color;
            [self.tabBar insertSubview:tabbg_view atIndex:0];
        }
    }
    else
    {
        // ios 7 code here
        // 设置tabbar的背景色
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)245/255 blue:(CGFloat)245/255 alpha:1];
        [self.tabBar insertSubview:view atIndex:0];
        // 设置选中后的文字(图标)颜色
        //[self.tabBar setTintColor:[UIColor colorFromHexRGB:@"4bba1f"]];
        [self.tabBar setTintColor:[UIColor colorWithRed:(CGFloat)158/255 green:(CGFloat)0/255 blue:(CGFloat)2/255 alpha:1]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
