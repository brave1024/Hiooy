//
//  ForgotViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  忘记密码...<不再使用>

#import <UIKit/UIKit.h>

@interface ForgotViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *txtfieldTel;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldVerify;
@property (strong, nonatomic) IBOutlet UIButton *btnGetVerify;

- (IBAction)getNewVerigy:(id)sender;

- (IBAction)getVerifyCode:(id)sender;

@end
