//
//  ChangePwdViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@property (nonatomic, strong) NSString *curVerifyCode;

@end

@implementation ChangePwdViewController

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
    self.navigationItem.title = @"修改密码";
    [self.navController showBackButtonWith:self];
    
//    self.txtfieldCurPwd.returnKeyType = UIReturnKeyNext;
//    self.txtfieldPwd.returnKeyType = UIReturnKeyNext;
//    self.txtfieldRepwd.returnKeyType = UIReturnKeyNext;
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnSubmit setBackgroundImage:img forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

//- (IBAction)getNewVerigy:(id)sender
//{
//    _curVerifyCode = [@"denty" uppercaseString];
//    [_btnGetVerify setImage:[UIImage imageNamed:@"img_verify_code"] forState:UIControlStateNormal];
//    [_btnGetVerify setTitle:@"" forState:UIControlStateNormal];
//}

- (IBAction)confirmClick:(id)sender
{
    [self changePwd];
}


#pragma mark - Private

- (void)changePwd
{
    
    [self allTextFieldResignFirstResponder];
    
    // 账号密码校验
    if ([_txtfieldCurPwd.text length] <= 0) {
        [self toast:@"请输入当前密码"];
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
    if ([_txtfieldRepwd.text length] < PwdMinLength) {
        int minLength = PwdMinLength;
        [self toast:[NSString stringWithFormat:@"密码长度不得小于%d位", minLength]];
        return;
    }
    if (![_txtfieldPwd.text isEqualToString:_txtfieldRepwd.text]) {
        [self toast:@"两次密码输入不一致"];
        return;
    }
//    if ([_txtfieldVerify.text length] <= 0) {
//        [self toast:@"请输入验证码"];
//        return;
//    }
//    if (![[_txtfieldVerify.text uppercaseString] isEqualToString:_curVerifyCode]) {
//        [self toast:@"请输入正确验证码"];
//        return;
//    }
    
    //[self allTextFieldResignFirstResponder];
    
    [self startLoading:kLoading];
    
    [[UserManager shareInstant] userChangePassword:self.txtfieldCurPwd.text withNewPassword:self.txtfieldPwd.text completion:^(BOOL isSucceed, NSString *message) {
        [self stopLoading];
        if (isSucceed)
        {
            [self toast:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self toast:message];
        }
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _txtfieldPwd || textField == _txtfieldRepwd || textField == _txtfieldCurPwd) {
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
    if ([_txtfieldCurPwd isFirstResponder]) {
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
    [_txtfieldPwd resignFirstResponder];
    [_txtfieldRepwd resignFirstResponder];
    [_txtfieldCurPwd resignFirstResponder];
}


#pragma mark - UITouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}



@end
