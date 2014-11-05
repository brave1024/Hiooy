//
//  BaseViewController.m
//  Megustek
//
//  Created by Lad on 13-4-10.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //LogTrace(@"  ==>> %@ did load", NSStringFromClass([self class]));
	// Do any additional setup after loading the view.
    
    //设置View背景
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg"]];
    // 425
    //self.view.backgroundColor = [UIColor colorFromHexRGB:@"efeff4"];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    if (__CUR_IOS_VERSION >= __IPHONE_7_0) {
        // This code will only compile on versions >= iOS 7.0
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知,ios5.0新增
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //LogTrace(@"   >>>>>>{ %@ } will appear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    //LogTrace(@"<<<<<<{ %@ } will disappear", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    LogError(@":%@ receive memory warning!!!", NSStringFromClass([self class]));
    // Dispose of any resources that can be recreated.
}

- (void)alertMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)startLoading:(NSString *)labelText
{
    if(labelText == nil || [labelText isEqualToString:@""])
    {
        labelText = @"加载中...";
    }
    //UIWindow *window = kAppWindow;
    //window.hidden = NO;
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:labelText];
}

- (void)stopLoading
{
    //UIWindow *window = kAppWindow;
    //window.hidden = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)toast:(NSString *)str
{
    if(str == nil || [str isEqualToString:@""])
    {
        return;
    }
    PGToast *toast = [PGToast makeToast:str];
    [toast show];
}

- (void)isNeedHidenTabbar:(BOOL)isNeed
{
    //isNeed = NO;//高保真不需隐藏工具栏
    float originY = isNeed ? 480:431;
    
    [UIView beginAnimations:nil context:NULL] ;
    [UIView setAnimationDuration:0.3];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,originY)];
        }
    }
    [UIView commitAnimations];
}


#pragma mark - Keyboard

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if ([duration doubleValue] > 0)
    {
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        if (keyboardRect.origin.y >= kScreenHeight - 5)
        {
            // 键盘隐藏
            //LogTrace(@" %@ keyboard will hide", NSStringFromClass([self class]));
            [self keyboardWillHide:notification];
        } else
        {
            // 键盘显示
            //LogTrace(@" %@ keyboard will show", NSStringFromClass([self class]));
            [self keyboardWillShow:notification];
        }
    } else
    {
        // 键盘高度变化，以后可修改为另一个方法
        //LogTrace(@" %@ keyboard change size", NSStringFromClass([self class]));
        [self keyboardWillShow:notification];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{

}


@end
