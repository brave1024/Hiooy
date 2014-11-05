//
//  BackNavItem.m
//  WorldAngle
//
//  Created by Xia Zhiyong on 14-3-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "BackNavItem.h"


@interface BackNavItem  ()

@property (nonatomic, strong) UIImageView *leftImageView;

@end



@implementation BackNavItem

//@synthesize leftImageView = _leftImageView;

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self = [super initWithTitle:title style:style target:target action:action];
    if (self)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        [self configSelfWithTitle:title type:UIBackNavDefault target:target action:action];
#else
        if (__CUR_IOS_VERSION >= __IPHONE_6_0)
        {
            [self configSelfWithTitle:title type:UIBackNavDefault target:target action:action];
        }
        else
        {
            [self configSelfWithTitle:title type:UIBackNavWhite target:target action:action];
        }
#endif
    }
    return self;
}

- (id)initWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action
{
    self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    if (self)
    {
        [self configSelfWithTitle:title type:type target:target action:action];
    }
    return self;
}

- (void)configSelfWithTitle:(NSString *)title type:(UIBackNavType)type target:(id)target action:(SEL)action
{
    UIColor *textColor = [UIColor colorWithRed:(CGFloat)77.0/255 green:(CGFloat)194.0/255 blue:(CGFloat)167.0/255 alpha:1];
    UIColor *highLightColor = [UIColor colorWithRed:(CGFloat)209/255 green:(CGFloat)239/255 blue:(CGFloat)231/255 alpha:1];
    NSString *backImage = @"btn_back";
    if (type == UIBackNavWhite)
    {
        textColor = [UIColor whiteColor];
        highLightColor = [UIColor lightGrayColor];
        backImage = @"myback";
    }
    
    // modified by xia zhiyong 1217
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn_back.frame = CGRectMake(0, 5, 32, 32);
    btn_back.frame = CGRectMake(0, 10, 28, 24);
    //[btn_back setTitle:title forState:UIControlStateNormal];
    [btn_back.titleLabel setTextColor:textColor];
    [btn_back.titleLabel setFont:[UIFont fontWithName:@"JXiHei" size:17]];
    [btn_back setTitleColor:textColor forState:UIControlStateNormal];
    [btn_back setTitleColor:highLightColor forState:UIControlStateHighlighted];
//    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
//    {
//        btn_back.titleEdgeInsets = UIEdgeInsetsMake(2, -15, 0, 0);
//        btn_back.imageEdgeInsets = UIEdgeInsetsMake(-1, -25, 0, 0);
//    }
//    else
//    {
//        btn_back.titleEdgeInsets = UIEdgeInsetsMake(2, -5, 0, 0);
//        btn_back.imageEdgeInsets = UIEdgeInsetsMake(-1, -15, 0, 0);
//    }
    [btn_back setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    //[btn_back setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [btn_back addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self setCustomView:btn_back];
}

@end
