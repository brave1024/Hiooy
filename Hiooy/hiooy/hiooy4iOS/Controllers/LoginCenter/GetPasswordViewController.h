//
//  GetPasswordViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-4.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  找回密码

#import <UIKit/UIKit.h>

@interface GetPasswordViewController : BaseViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldVerify;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldRepwd;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnVerify;

@property (nonatomic, strong) NSMutableArray *arrayEdit;      // 存放视图中可编辑的控件
@property (nonatomic, strong) KeyBoardTopBar *keyboardbar;    //

- (IBAction)submitAction:(id)sender;

@end
