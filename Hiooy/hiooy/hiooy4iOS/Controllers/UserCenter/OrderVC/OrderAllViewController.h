//
//  OrderAllViewController.h
//  hiooy
//
//  Created by retain on 14-5-7.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  全部订单

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
#import "OrderListCell.h"
#import "OrderFootView.h"

@interface OrderAllViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, OrderFootViewDelegate, PullTableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) OrderInfoModel *orderList;

@property (nonatomic, weak) IBOutlet UIView *viewNoData;

@end
