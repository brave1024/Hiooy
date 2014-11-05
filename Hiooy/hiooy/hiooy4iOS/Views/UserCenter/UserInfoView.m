//
//  UserInfoView.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-27.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfoModel.h"

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UserInfoView *)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] objectAtIndex:0];
}

- (void)settingView:(id)data
{
    // 头像
    _viewAvatar.layer.cornerRadius = _viewAvatar.bounds.size.width / 2;
    _viewAvatar.layer.masksToBounds = YES;
    _imgviewAvatar.layer.cornerRadius = _imgviewAvatar.bounds.size.width / 2;
    _imgviewAvatar.layer.masksToBounds = YES;
    
    UserInfoModel *userModel = (UserInfoModel *)data;
    self.lblTel.text = userModel.login_name;
    self.lblUserLevel.text = userModel.levelname;
    self.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f", [userModel.advance.total floatValue]];
}


@end
