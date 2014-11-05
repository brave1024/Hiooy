//
//  SecondKillListViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  秒杀列表界面

#import <UIKit/UIKit.h>
#import "ActivityListModel.h"

@interface SecondKillListViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) ActivityListModel *listModel;

@property (nonatomic, strong) NSTimer *timer;
@property int rTime;

@end
