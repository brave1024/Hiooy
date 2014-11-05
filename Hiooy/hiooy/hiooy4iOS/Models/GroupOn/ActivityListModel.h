//
//  ActivityListModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  团购、秒杀列表接口返回的数据实体

#import <Foundation/Foundation.h>
#import "ActivityItemModel.h"
#import "PagerModel.h"

@interface ActivityListModel : JSONModel

@property (nonatomic, strong) PagerModel<Optional> *pages;
@property (nonatomic, strong) NSArray<ActivityItemModel, Optional> *sales;

@end
