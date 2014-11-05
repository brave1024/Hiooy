//
//  BackNavItem.h
//  WorldAngle
//
//  Created by Xia Zhiyong on 14-3-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  导航栏返回键

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBackNavType)
{
    UIBackNavDefault,
    UIBackNavWhite
};

@interface BackNavItem : UIBarButtonItem

- (id)initWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action;

@end
