//
//  ResetPwdViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  重设密码...<不再使用>

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *txtfieldVerify;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldRepwd;

- (IBAction)setPwdClick:(id)sender;

@end
