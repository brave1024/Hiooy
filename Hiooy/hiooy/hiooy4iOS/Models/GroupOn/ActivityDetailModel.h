//
//  ActivityDetailModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-9.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityProductModel.h"

@interface ActivityDetailModel : JSONModel

@property (nonatomic, strong) NSArray<ActivityProductModel, Optional> *products;    // 若多于一个元素,则表示为规格商品
@property (nonatomic, strong) NSArray<Optional> *images;                // 商品组图
@property (nonatomic, copy) NSString<Optional> *type;                   // 活动类型
@property (nonatomic, copy) NSString<Optional> *goods_id;               // 活动商品id
@property (nonatomic, copy) NSString<Optional> *name;                   // 活动名称
@property (nonatomic, copy) NSString<Optional> *buy;                    // 已经购买量（已付款）
@property (nonatomic, copy) NSString<Optional> *start_value;            // 起始值(后台假设已购量)
@property (nonatomic, copy) NSString<Optional> *min_buy;                // 最小购买量
@property (nonatomic, copy) NSString<Optional> *max_buy;                // 最大购买量（满足时活动结束）
@property (nonatomic, copy) NSString<Optional> *userlimit;              // 每人限购
@property (nonatomic, copy) NSString<Optional> *price;                  // 活动价
@property (nonatomic, copy) NSString<Optional> *pro_type;               // 优惠类型（1=>达到一定费用免运费 2=>无邮费优惠）
@property (nonatomic, copy) NSString<Optional> *postage;                // 邮费优惠
@property (nonatomic, copy) NSString<Optional> *state;                  // 活动状态(1=>未开始 2=>进行中 3=>已结束（成功）4=>已结束，待处理 5=>已结束（失败）)
@property (nonatomic, copy) NSString<Optional> *intro;                  // 活动说明
@property (nonatomic, copy) NSString<Optional> *start_time;             // 开始时间
@property (nonatomic, copy) NSString<Optional> *end_time;               // 结束时间
@property (nonatomic, copy) NSString<Optional> *old_price;              // 商品原价
@property (nonatomic, copy) NSString<Optional> *sales;                  // 折扣

@end
