//
//  LoginViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgotViewController.h"
#import "ChangePwdViewController.h"
#import "GetPasswordViewController.h"
#import "AppDelegate.h"
#import "ShoppingCartViewController.h"
#import "MyHiooyViewController.h"

@interface LoginViewController ()
@property CGRect viewRect;
@end

@implementation LoginViewController

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
    self.navigationItem.title = @"登录";
    //[self.navController showBackButtonWith:self];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 6, 48, 32);
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    //[btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_ico_press"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 忘记密码添加下划线
    NSMutableAttributedString *strForgot = [_btnForgotPwd.titleLabel.attributedText mutableCopy];
    NSRange rangeAll = NSMakeRange(0, strForgot.string.length);
    [strForgot beginEditing];
    [strForgot addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:YES] range:rangeAll];
    [strForgot endEditing];
    _btnForgotPwd.titleLabel.attributedText = strForgot;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDef objectForKey:kUserName];
    if (name != nil)
    {
        self.txtfieldAccount.text = name;
        [_txtfieldPwd becomeFirstResponder];
    }
    else
    {
        [_txtfieldAccount becomeFirstResponder];
    }
    
    UIImage *img = [UIImage imageNamed:@"btn_red"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnLogin setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *imgY = [UIImage imageNamed:@"btn_yellow"];
    imgY = [imgY resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    [self.btnRegister setBackgroundImage:imgY forState:UIControlStateNormal];
    
    _arrayEdit = [[NSMutableArray alloc] initWithObjects:self.txtfieldAccount, self.txtfieldPwd, nil];
    
    _keyboardbar = [[KeyBoardTopBar alloc] init];
    [_keyboardbar setAllowShowPreAndNext:YES];
    [_keyboardbar setIsInNavigationController:NO];
    [_keyboardbar setTextFieldsArray:_arrayEdit];
    
    self.txtfieldAccount.inputAccessoryView = _keyboardbar.view;
    self.txtfieldPwd.inputAccessoryView = _keyboardbar.view;
    
    self.scrollview.contentSize = CGSizeMake(320, 215);
    _viewRect = self.scrollview.frame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        // 需判断显示哪个tab
        int currentIndex = kAppDelegate.tabVC.selectedIndex;
        if (currentIndex >= 2)
        {
            kAppDelegate.tabVC.selectedIndex = 0;
        }
    }];
}


#pragma mark - Action

- (IBAction)showForgotPwd:(id)sender
{
//    ForgotViewController *forgotVC = [[ForgotViewController alloc] initWithNibName:@"ForgotViewController" bundle:nil];
//    [self.navigationController pushViewController:forgotVC animated:YES];
    GetPasswordViewController *passwordVC = [[GetPasswordViewController alloc] initWithNibName:@"GetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (IBAction)showRegister:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)loginClick:(id)sender
{
    [self doLogin];
}


#pragma mark - Private

// 0:账号、密码不能为空 1:手机号不合法 2:邮箱不合法 3:账号不合法(非手机号或邮箱)
// 4:手机号 5 邮箱
- (int)checkAccountContent
{
    NSString *account = self.txtfieldAccount.text;
    
    // 先判断是否为空
    BOOL isValid = [TextVerifyHelper checkContent:account];
    if (isValid == NO)
    {
        [self toast:@"账号/密码不能为空"];
        return 0;
    }
    isValid = [TextVerifyHelper checkContent:self.txtfieldPwd.text];
    if (isValid == NO)
    {
        [self toast:@"账号/密码不能为空"];
        return 0;
    }
    
    // 再判断类型 及 合法性
    
    // 1手机号(纯数字) or 2邮箱(带@符号) or 0其它
    int flag = [TextVerifyHelper checkAccountType:account];
    if (flag == 1)
    {
        BOOL isOk = [TextVerifyHelper checkPhone:account];
        if (isOk == NO)
        {
            return 1;
        }
        else
        {
            return 4;
        }
    }
    else if (flag == 2)
    {
        BOOL isOK = [TextVerifyHelper checkMailAddress:account];
        if (isOK == NO)
        {
            return 2;
        }
        else
        {
            return 5;
        }
    }
    else
    {
        return 3;
    }
    
    //return 0;   // 默认返回0
}

// 登录
- (void)doLogin
{
    
    [self allTextFieldResignFirstResponder];
    
    int flag = [self checkAccountContent];
    int type = 1;   // 默认为手机号登录
    
    if (flag == 1)
    {
        [self toast:@"请输入正确的手机号"];
        return;
    }
    else if (flag == 2)
    {
        [self toast:@"请输入正确的邮箱地址"];
        return;
    }
    else if (flag == 3)
    {
        [self toast:@"请输入正确的账号(手机号或邮箱)"];
        return;
    }
    else if (flag == 0)
    {
        [self toast:@"账号/密码不能为空"];
        return;
    }
    else if (flag == 4) // 手机号登录
    {
        type = 1;
    }
    else if (flag == 5) // 邮箱登录
    {
        type = 2;
    }
    else
    {
        //
    }
    
    if (self.txtfieldPwd.text.length < 6)
    {
        [self toast:@"密码长度不得小于6位"];
        return;
    }
    
    [self startLoading:kLoading];
    
    [[UserManager shareInstant] userLogin:_txtfieldAccount.text withPassword:_txtfieldPwd.text andType:[NSString stringWithFormat:@"%d", type] completion:^(BOOL isSucceed, NSString *message) {
        [self stopLoading];
        if (isSucceed)
        {
//            if (_completionBlock)
//            {
//                _completionBlock(isSucceed, message);
//            }
            [self dismissViewControllerAnimated:YES completion:^{
                // 登录成功后,需选择指定的tab
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                int tabIndex = appDelegate.willSelectedIndex;
                if (tabIndex == 2 || tabIndex == 3)  // 若是进入购物车界面 or 个人中心界面,则需要刷新
                {
                    NSArray *arrayVC = [appDelegate.tabVC viewControllers];
                    for (int i = 0; i < arrayVC.count; i++)
                    {
                        UIViewController *vc = [arrayVC objectAtIndex:i];
                        if ([vc isKindOfClass:[UINavigationController class]] == YES)
                        {
                            UINavigationController *navVC = (UINavigationController *)vc;
                            vc = [navVC.viewControllers objectAtIndex:0];   // 指定nav栈中的第0个vc
                        }
                        if ([vc isKindOfClass:[ShoppingCartViewController class]] == YES && tabIndex == 2)
                        {
                            ShoppingCartViewController *cartVC = (ShoppingCartViewController  *)vc;
                            [cartVC requestShoppingCartList];
                            break;
                        }
                        else if ([vc isKindOfClass:[MyHiooyViewController class]] == YES && tabIndex == 3)
                        {
                            MyHiooyViewController *hiooyVC = (MyHiooyViewController *)vc;
                            [hiooyVC requestUserCenter];
                            break;
                        }
                    }
                }
                appDelegate.tabVC.selectedIndex = tabIndex;
            }];
        }
        else
        {
            [self toast:message];
        }
    }];
    
}

/*
{
    "status": "success",
    "msg": "您已经是登录状态，不需要重新登录",
    "data": ""
}
*/


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _txtfieldAccount) {
        if (range.location >= AccountMaxLength) {
            int maxLength = AccountMaxLength;
            [self toast:[NSString stringWithFormat:@"账号长度不得超过%d位", maxLength]];
            return NO;
        }
    } else if (textField == _txtfieldPwd) {
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
    if ([_txtfieldAccount isFirstResponder]) {
        [_txtfieldPwd becomeFirstResponder];
    } else {
        LogTrace(@" {Button Click} : keyboard return");
        [self performSelector:@selector(doLogin)];
    }
    return  YES;
}

- (void)allTextFieldResignFirstResponder
{
    [_txtfieldAccount resignFirstResponder];
    [_txtfieldPwd resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // KeyBoardTopBar的实例对象调用显示键盘方法
    [_keyboardbar showBar:textField];
}


# pragma mark - UITouchEvent

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
