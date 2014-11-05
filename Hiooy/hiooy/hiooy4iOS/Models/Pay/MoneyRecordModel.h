//
//  MoneyRecordModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预存款消费记录接口返回的数据实体

#import <Foundation/Foundation.h>
#import "RecordItemModel.h"
#import "PagerModel.h"

@interface MoneyRecordModel : JSONModel

@property (nonatomic, strong) NSArray<RecordItemModel, Optional> *balance;  // 消费数据实体
@property (nonatomic, strong) PagerModel<Optional> *pager;                  // 分页数据实体
@property (nonatomic, copy) NSString<Optional> *total;                      // 当前余额

@end
