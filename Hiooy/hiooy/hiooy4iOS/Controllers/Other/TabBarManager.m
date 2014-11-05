//
//  TabBarManager.m
//  hiooy
//
//  Created by 黄磊 on 14-3-21.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "TabBarManager.h"
#import "NavigationViewController.h"
#import "TabBarViewController.h"
#import "LifeCircleViewController.h"
#import "MyHiooyViewController.h"
#import "MoreViewController.h"
#import "MainViewController.h"
#import "ShoppingCartViewController.h"
#import "UserManager.h"
#import "AppDelegate.h"

@implementation TabBarManager

- (id)initWithTabBar:(TabBarViewController *)tabBarController
{
    self = [super init];
    if (self) {
        self.tabBarController = tabBarController;
    }
    return self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)viewController;
        viewController = [navVC.viewControllers objectAtIndex:0];   // 指定nav栈中的第0个vc
    }
    // modified by xzy
    // 只在此处判断当前用户是否登录;若未登录,则弹出登录界面
    if ([viewController isKindOfClass:[ShoppingCartViewController class]])
    {
        if ([[UserManager shareInstant] isLogin])
        {
            // 刷新购物车
            ShoppingCartViewController *cartVC = (ShoppingCartViewController *)viewController;
            [cartVC requestShoppingCartList];
            return YES;
        }
        else
        {
            ShoppingCartViewController *cartVC = (ShoppingCartViewController *)viewController;
            [cartVC showUserLogin];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.willSelectedIndex = 2;
            return NO;
        }
    }
    else if ([viewController isKindOfClass:[MyHiooyViewController class]])
    {
        if ([[UserManager shareInstant] isLogin])
        {
            // 刷新个人中心
            MyHiooyViewController *hiooyVC = (MyHiooyViewController *)viewController;
            [hiooyVC requestUserCenter];
            return YES;
        }
        else
        {
            MyHiooyViewController *hiooyVC = (MyHiooyViewController *)viewController;
            [hiooyVC showUserLogin];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.willSelectedIndex = 3;
            return NO;
        }
    }
    
//    if ([viewController isKindOfClass:[LifeCircleViewController class]]) {
//        if (tabBarController.sliderViewController.curDisplayView == kDisplayLeftView) {
//            [tabBarController.sliderViewController showCenterView];
//        } else {
//            [tabBarController.sliderViewController showLeftView];
//        }
//        return NO;
//    } else if ([viewController isKindOfClass:[MyHiooyViewController class]]) {
//        if ([[UserManager shareInstant] isLogin]) {
//            return YES;
//        } else {
//            MyHiooyViewController *theMainVC = (MyHiooyViewController *)viewController;
//            [theMainVC showUserLogin];
//            return NO;
//        }
//    } else if ([viewController isKindOfClass:[MoreViewController class]]) {
//        if (tabBarController.sliderViewController.curDisplayView == kDisplayRightView) {
//            [tabBarController.sliderViewController showCenterView];
//        } else {
//            [tabBarController.sliderViewController showRightView];
//        }
//        return NO;
//    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

@end
