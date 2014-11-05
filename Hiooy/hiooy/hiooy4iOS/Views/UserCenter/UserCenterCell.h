//
//  UserCenterCell.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//  商户中心界面 （LeftViewController）

#import <UIKit/UIKit.h>

@interface UserCenterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgviewIcon;    // 左边图标
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;           // 该项名称
@property (nonatomic, strong) IBOutlet UIImageView *imgviewArrow;   // 右边小箭头

@property (nonatomic, strong) IBOutlet UIView *viewNew;             // 右边附加视图
@property (nonatomic, strong) IBOutlet UILabel *lblNew;             // 右边附加信息
@property (nonatomic, strong) IBOutlet UIImageView *imgviewNew;     // 背景图标


@end
