//
//  SettingViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  设置

#import <UIKit/UIKit.h>
#import "SettingBtnCell.h"
#import "SettingSwitchCell.h"

@interface SettingViewController : BaseViewController <SettingBtnCellDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;

- (IBAction)logoutAction:(id)sender;

@end
