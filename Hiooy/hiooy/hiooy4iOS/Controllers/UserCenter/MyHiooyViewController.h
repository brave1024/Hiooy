//
//  MyHiooyViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  用户中心

#import <UIKit/UIKit.h>

@interface MyHiooyViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UIView *viewAvatar;
//@property (strong, nonatomic) IBOutlet UIImageView *imgviewAvatar;
//@property (strong, nonatomic) IBOutlet UILabel *lblTel;         // 用户名
//@property (strong, nonatomic) IBOutlet UILabel *lblUserLevel;   // 等级
//@property (strong, nonatomic) IBOutlet UILabel *lblMoney;       // 账户余额

@property (strong, nonatomic) UserInfoModel *userModel;

- (void)showUserLogin;
- (void)requestUserCenter;

@end
