//
//  SettingCell.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//  商户中心界面 （LeftViewController）

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;           // 该项名称
@property (nonatomic, strong) IBOutlet UILabel *lblRight;           // 右边附件信息
@property (nonatomic, strong) IBOutlet UIImageView *imgviewRight;   // 右边小箭头
//@property (nonatomic, strong) IBOutlet UIImageView *imgviewNew;     // 是否是最新图标

@end
