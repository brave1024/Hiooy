//
//  AppDelegate.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *leftWindow;
@property (nonatomic, assign) BOOL haveNewVersion;
@property int willSelectedIndex;
@property int currentSelectedIndex;
@property (strong, nonatomic) TabBarViewController *tabVC;

// 显示右边视图
- (void)showLeftView;

// 显示主视图
- (void)showMainView;

/**
 *	@brief	获取根视图
 *
 *	@return	根视图，这里是SlideViewController
 */
- (UIViewController *)getRootViewController;

/**
 *	@brief	获取顶层视图
 *
 *	@return	顶层视图
 */
//- (UIViewController *)topViewController;

- (BOOL)openURL:(NSURL*)url;

@end
