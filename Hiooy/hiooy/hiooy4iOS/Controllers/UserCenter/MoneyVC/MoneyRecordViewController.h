//
//  MoneyRecordViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预充款消费记录

#import <UIKit/UIKit.h>
#import "MoneyRecordModel.h"

@interface MoneyRecordViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (nonatomic, strong) IBOutlet PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) MoneyRecordModel *recordData;

@property (nonatomic, weak) IBOutlet UIView *viewNoData;

@end
