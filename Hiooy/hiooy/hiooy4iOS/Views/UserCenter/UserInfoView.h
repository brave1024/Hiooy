//
//  UserInfoView.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;         // 用户名
@property (weak, nonatomic) IBOutlet UILabel *lblUserLevel;   // 等级
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;       // 账户余额

+ (UserInfoView *)viewFromNib;
- (void)settingView:(id)data;

@end
