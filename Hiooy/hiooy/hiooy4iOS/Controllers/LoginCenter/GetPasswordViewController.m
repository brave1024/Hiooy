//
//  GetPasswordViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-4.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "GetPasswordViewController.h"

@interface GetPasswordViewController ()
@property CGRect viewRect;
@property (nonatomic, strong) NSTimer *timer;
@property int count;
@end

@implementation GetPasswordViewController

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
    
    self.navigationItem.title = @"密码找回";
    [self.navController showBackButtonWith:self];
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnSubmit setBackgroundImage:img forState:UIControlStateNormal];

    UIImage *img_ = [UIImage imageNamed:@"red_btn"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(6, 2, 6, 2)];
    [self.btnVerify setBackgroundImage:img_ forState:UIControlStateNormal];
    [self.btnVerify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    _arrayEdit = [[NSMutableArray alloc] initWithObjects:self.txtfieldMobile, self.txtfieldVerify, self.txtfieldPwd, self.txtfieldRepwd, nil];
    
    _keyboardbar = [[KeyBoardTopBar alloc] init];
    [_keyboardbar setAllowShowPreAndNext:YES];
    [_keyboardbar setIsInNavigationController:NO];
    [_keyboardbar setTextFieldsArray:_arrayEdit];
    
    self.txtfieldMobile.inputAccessoryView = _keyboardbar.view;
    self.txtfieldVerify.inputAccessoryView = _keyboardbar.view;
    self.txtfieldPwd.inputAccessoryView = _keyboardbar.view;
    self.txtfieldRepwd.inputAccessoryView = _keyboardbar.view;
    
    self.scrollview.contentSize = CGSizeMake(320, 275);
    _viewRect = self.scrollview.frame;
    
    self.count = 90;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)submitAction:(id)sender
{
    [self allTextFieldResignFirstResponder];
    
    // 账号密码校验
    
    if ([TextVerifyHelper checkContent:self.txtfieldMobile.text] == NO) {
        [self toast:@"请输入手机号"];
        return;
    }
    if (![_txtfieldMobile.text checkMobileNum]) {
        [self toast:@"请输入正确的手机号"];
        return;
    }
    if ([TextVerifyHelper checkContent:self.txtfieldVerify.text] == NO) {
        [self toast:@"请输入验证码"];
        return;
    }
    if ([TextVerifyHelper checkContent:self.txtfieldPwd.text] == NO) {
        [self toast:@"请输入密码"];
        return;
    }
    if ([TextVerifyHelper checkContent:self.txtfieldRepwd.text] == NO) {
        [self toast:@"请再次输入密码"];
        return;
    }
    if ([_txtfieldPwd.text isEqualToString:_txtfieldRepwd.text] == NO) {
        [self toast:@"密码不一致,请重新输入"];
        return;
    }
    // 检查密码长度
    if (self.txtfieldPwd.text.length < 6)
    {
        [self toast:@"密码长度不得小于6位"];
        return;
    }
    else if (self.txtfieldPwd.text.length > 20)
    {
        [self toast:@"密码长度不得超过20位"];
        return;
    }
    
    [self startLoading:kLoading];
    
    [[UserManager shareInstant] userGetPassword:self.txtfieldMobile.text withVerify:self.txtfieldVerify.text andPasswrod:self.txtfieldPwd.text completion:^(BOOL isSucceed, NSString *message) {
        [self stopLoading];
        if (isSucceed)
        {
            [self toast:message];
            [self dismissViewControllerAnimated:YES completion:^{
                //
            }];
        }
        else
        {
            [self toast:message];
        }
    }];
}


- (IBAction)getVerifyCode:(id)sender
{
    // 手机号检测
    if ([TextVerifyHelper checkContent:self.txtfieldMobile.text] == NO)
    {
        [self toast:@"请输入手机号"];
        return;
    }
    if (![_txtfieldMobile.text checkMobileNum])
    {
        [self toast:@"请输入正确的手机号"];
        return;
    }
    
    self.btnVerify.enabled = NO;
    [self.btnVerify setTitle:@"获取验证码" forState:UIControlStateDisabled];
    
    // type: 1-注册 2-忘记密码
    [[UserManager shareInstant] userGetVerifyCode:self.txtfieldMobile.text withType:@"2" completion:^(BOOL isSucceed, NSString *message) {
        if (isSucceed)
        {
            self.btnVerify.enabled = NO;
            [self toast:@"验证码发送成功"];
            // 开始倒计时
            self.count = 90;
            [self.btnVerify setTitle:@"90s后再次获取" forState:UIControlStateDisabled];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        }
        else
        {
            NSLog(@"%@", message);
            // 请求失败,重新获取
            [self toast:message];
            self.btnVerify.enabled = YES;
        }
    }];
}

#pragma mark - Private

- (void)timeCount
{
    self.count--;
    if (self.count <= 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        //[self.btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.btnVerify.enabled = YES;
    }
    else
    {
        NSLog(@"count:%d", self.count);
        [self.btnVerify setTitle:[NSString stringWithFormat:@"%ds后再次获取", self.count] forState:UIControlStateDisabled];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _txtfieldPwd) {
        if (range.location >= PwdMaxLength) {
            int maxLength = PwdMaxLength;
            [self toast:[NSString stringWithFormat:@"密码长度不得超过%d位", maxLength]];
            return NO;
        }
    } else if (textField == _txtfieldRepwd) {
        if (range.location >= PwdMaxLength) {
            int maxLength = PwdMaxLength;
            [self toast:[NSString stringWithFormat:@"密码长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    return  YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if ([_txtfieldEmail isFirstResponder]) {
//        [_txtfieldAccount becomeFirstResponder];
//    } else if ([_txtfieldAccount isFirstResponder]) {
//        [_txtfieldPwd becomeFirstResponder];
//    } else if ([_txtfieldPwd isFirstResponder]) {
//        [_txtfieldRepwd becomeFirstResponder];
//    } else {
//        LogTrace(@" {Button Click} : keyboard return");
//        [self performSelector:@selector(doRegister)];
//    }
//    return  YES;
//}

- (void)allTextFieldResignFirstResponder
{
    [_txtfieldMobile resignFirstResponder];
    [_txtfieldVerify resignFirstResponder];
    [_txtfieldPwd resignFirstResponder];
    [_txtfieldRepwd resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // KeyBoardTopBar的实例对象调用显示键盘方法
    [_keyboardbar showBar:textField];
}


#pragma mark - UITouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height; // 获取键盘高度
    //NSLog(@"<keyboardHeight:%f>",keyboardHeight);
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;   // 键盘动画时间
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat scrollHeight = kScreenHeight - 64 - keyboardHeight;
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //[self.scrollview setContentOffset:CGPointMake(0, self.viewNumberS.frame.origin.y) animated:YES];
        self.scrollview.frame = CGRectMake(0, 0, 320, scrollHeight);
    } completion:^(BOOL finished) {
        //
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        //[self.scrollview setContentOffset:CGPointMake(0, self.scrollviewS.contentSize.height-self.scrollviewS.frame.size.height) animated:YES];
        self.scrollview.frame = self.viewRect;
    } completion:^(BOOL finished) {
        //
    }];
    
}


@end
