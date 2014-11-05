//
//  BaseViewController.h
//  Megustek
//
//  Created by Lad on 13-4-10.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PGToast.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#define DEFAULT_DIS_EYE 60.0f
#define DEFAULT_DIS_LEFT 135.75f
#define DEFAULT_DIS_TOP 182.5f

@interface BaseViewController : UIViewController <UITextFieldDelegate>
{
    //加载框
//    MBProgressHUD *progressHUD;
}

/**
 *	@brief	提示
 *
 *	@param 	msg 	提示信息
 */
- (void)alertMsg:(NSString*)msg;

/**
 *	@brief	显示加载框
 *
 *	@param 	labelText 	加载框显示内容
 */
- (void)startLoading:(NSString *)labelText;

/**
 *	@brief	隐藏加载框
 */
- (void)stopLoading;

/**
 *	@brief	弹出底部的提示文字
 *
 *	@param 	str 需要弹出的字符串
 */
- (void)toast:(NSString *)str;

- (void)isNeedHidenTabbar:(BOOL)isNeed;

@end
