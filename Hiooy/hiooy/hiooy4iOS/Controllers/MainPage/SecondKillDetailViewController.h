//
//  SecondKillDetailViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-5.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  秒杀详情界面...<不再使用,与团购详情共用界面>

#import <UIKit/UIKit.h>
#import "ActivityItemModel.h"
#import "ActivityDetailModel.h"

@interface SecondKillDetailViewController : BaseViewController

@property (nonatomic, strong) ActivityItemModel *activityItem;
@property (nonatomic, strong) ActivityDetailModel *activityDetail;

@end
