//
//  TabBarManager.h
//  hiooy
//
//  Created by 黄磊 on 14-3-21.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TabBarManager : NSObject <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;

- (id)initWithTabBar:(UITabBarController *)tabBarController;

@end

