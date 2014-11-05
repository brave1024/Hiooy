//
//  OrderInfoModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  订单列表接口返回的整体数据实体

#import <Foundation/Foundation.h>
#import "OrderItemModel.h"
#import "PagerModel.h"

@interface OrderInfoModel : JSONModel

@property (nonatomic, strong) PagerModel *pager;
@property (nonatomic, strong) NSArray<OrderItemModel> *list;

@end
