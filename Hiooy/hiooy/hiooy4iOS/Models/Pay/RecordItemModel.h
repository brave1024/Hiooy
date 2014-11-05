//
//  RecordItemModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-23.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  预存款消费记录实体中的单个消费实体

#import <Foundation/Foundation.h>

@protocol RecordItemModel <NSObject>

@end


@interface RecordItemModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *mtime;                // 交易时间
@property (nonatomic, copy) NSString<Optional> *message;              // 预存款支付订单 明细
@property (nonatomic, copy) NSString<Optional> *import_money;         // 存入金额
@property (nonatomic, copy) NSString<Optional> *explode_money;        // 支出金额
@property (nonatomic, copy) NSString<Optional> *member_advance;       // 当前余额

@end
