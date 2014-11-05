//
//  ResetPwdViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ResetPwdViewController.h"

@interface ResetPwdViewController ()

@property (nonatomic, strong) NSString *curVerifyCode;

@end

@implementation ResetPwdViewController

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
    self.navigationItem.title = @"重置密码";
    [self.navController showBackButtonWith:self];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)setPwdClick:(id)sender
{
    [self changePwd];
}


#pragma mark - Private

- (void)changePwd
{
    
    [self allTextFieldResignFirstResponder];
    
    // 账号密码校验
    
    if ([_txtfieldVerify.text length] <= 0) {
        [self toast:@"请输入短信验证码"];
        return;
    }
    if ([_txtfieldVerify.text length] < 6) {
        [self toast:@"请输入正确短信验证码"];
        return;
    }
    if ([_txtfieldPwd.text length] <= 0) {
        [self toast:@"请输入新密码"];
        return;
    }
    if ([_txtfieldPwd.text length] < PwdMinLength) {
        int minLength = PwdMinLength;
        [self toast:[NSString stringWithFormat:@"密码长度不得小于%d位", minLength]];
        return;
    }
    if ([_txtfieldRepwd.text length] <= 0) {
        [self toast:@"请重复输入新密码"];
        return;
    }
    if (![_txtfieldPwd.text isEqualToString:_txtfieldRepwd.text]) {
        [self toast:@"两次输入密码不一致"];
        return;
    }
    // 校验正确验证码
    [self allTextFieldResignFirstResponder];
    [self toast:@"密码修改成功"];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _txtfieldVerify) {
        if (range.location >= VerifyMaxLength) {
            int maxLength = VerifyMaxLength;
            [self toast:[NSString stringWithFormat:@"验证码长度不得超过%d位", maxLength]];
            return NO;
        }
    } else if (textField == _txtfieldPwd || textField == _txtfieldRepwd) {
        if (range.location >= PwdMaxLength) {
            int maxLength = PwdMaxLength;
            [self toast:[NSString stringWithFormat:@"密码长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_txtfieldVerify isFirstResponder]) {
        [_txtfieldPwd becomeFirstResponder];
    } else if ([_txtfieldPwd isFirstResponder]) {
        [_txtfieldRepwd becomeFirstResponder];
    } else {
        LogTrace(@" {Button Click} : keyboard return");
        [self performSelector:@selector(changePwd)];
    }
    return  YES;
}

- (void)allTextFieldResignFirstResponder
{
    [_txtfieldVerify resignFirstResponder];
    [_txtfieldPwd resignFirstResponder];
    [_txtfieldRepwd resignFirstResponder];
}

# pragma mark - UITouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}


@end
