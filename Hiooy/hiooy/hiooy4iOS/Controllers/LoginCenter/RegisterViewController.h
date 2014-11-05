//
//  RegisterViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  注册

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldVerify;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldRepwd;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnVerify;

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

- (IBAction)registerClick:(id)sender;
- (IBAction)getVerifyCode:(id)sender;

@end
