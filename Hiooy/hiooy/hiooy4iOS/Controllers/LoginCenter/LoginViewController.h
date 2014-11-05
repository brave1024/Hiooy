//
//  LoginViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  登录

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface LoginViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldAccount;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldPwd;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPwd;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) UserManagerBlock completionBlock;

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

- (IBAction)showForgotPwd:(id)sender;
- (IBAction)showRegister:(id)sender;
- (IBAction)loginClick:(id)sender;

@end
