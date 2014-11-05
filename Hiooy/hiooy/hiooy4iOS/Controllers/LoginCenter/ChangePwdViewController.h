//
//  ChangePwdViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  修改密码

#import <UIKit/UIKit.h>

@interface ChangePwdViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *txtfieldCurPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtfieldRepwd;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

//- (IBAction)getNewVerigy:(id)sender;
- (IBAction)confirmClick:(id)sender;

@end
