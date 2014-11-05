//
//  ForgotViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ForgotViewController.h"
#import "ResetPwdViewController.h"

@interface ForgotViewController ()

@property (nonatomic, strong) NSString *curVerifyCode;

@end

@implementation ForgotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"忘记密码";
    [self.navController showBackButtonWith:self];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)getNewVerigy:(id)sender {
    [self getNewVerigyCode];
}

- (IBAction)getVerifyCode:(id)sender {
    [self checkVerifyCode];
}


#pragma mark - Private

- (void)getNewVerigyCode
{
    _curVerifyCode = @"denty";
    [_btnGetVerify setImage:[UIImage imageNamed:@"img_verify_code"] forState:UIControlStateNormal];
    [_btnGetVerify setTitle:@"" forState:UIControlStateNormal];
}

- (void)checkVerifyCode
{
    
    [self allTextFieldResignFirstResponder];
    
    // 账号密码校验
    
    if ([_txtfieldTel.text length] <= 0) {
        [self toast:@"请输入手机号"];
        return;
    }
    if (![_txtfieldTel.text checkMobileNum]) {
        [self toast:@"请输入正确手机号"];
        return;
    }
    if ([_txtfieldVerify.text length] <= 0) {
        [self toast:@"请输入验证码"];
        return;
    }
    if (![_txtfieldVerify.text isEqualToString:_curVerifyCode]) {
        [self toast:@"请输入正确验证码"];
        return;
    }
    // 校验正确验证码
    [self allTextFieldResignFirstResponder];
    
    ResetPwdViewController *setpwdVC = [[ResetPwdViewController alloc] initWithNibName:@"ResetPwdViewController" bundle:nil];
    [self.navigationController pushViewController:setpwdVC animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _txtfieldTel) {
        if (range.location >= TelMaxLength) {
            int maxLength = TelMaxLength;
            [self toast:[NSString stringWithFormat:@"手机号长度不得超过%d位", maxLength]];
            return NO;
        }
    } else if (textField == _txtfieldVerify) {
        if (range.location >= VerifyMaxLength) {
            int maxLength = VerifyMaxLength;
            [self toast:[NSString stringWithFormat:@"验证码长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_txtfieldTel isFirstResponder]) {
        [_txtfieldVerify becomeFirstResponder];
    } else {
        LogTrace(@" {Button Click} : keyboard return");
        [self performSelector:@selector(checkVerifyCode)];
    }
    return  YES;
}

- (void)allTextFieldResignFirstResponder
{
    [_txtfieldTel resignFirstResponder];
    [_txtfieldVerify resignFirstResponder];
}


#pragma mark - UITouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}

@end
