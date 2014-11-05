//
//  ActivityItemModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-3.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  团购、秒杀列表接口中的单个商品实体

#import <Foundation/Foundation.h>

@protocol ActivityItemModel <NSObject>

@end


@interface ActivityItemModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *act_id;         // 活动id
@property (nonatomic, copy) NSString<Optional> *name;           // 名称
@property (nonatomic, copy) NSString<Optional> *price;          // 活动价格
@property (nonatomic, copy) NSString<Optional> *gid;            // 活动商品id：goods_id
@property (nonatomic, copy) NSString<Optional> *image_url;      // 缩略图
@property (nonatomic, copy) NSString<Optional> *old_price;      // 原价
@property (nonatomic, copy) NSString<Optional> *end_time;       // 结束时间
@property (nonatomic, copy) NSString<Optional> *start_time;     // 开始时间
@property (nonatomic, copy) NSString<Optional> *min_buy;        // 最少购买量
@property (nonatomic, copy) NSString<Optional> *seller_id;      // 商户id
@property (nonatomic, copy) NSString<Optional> *buy;            // 已购数量（已支付）
@property (nonatomic, copy) NSString<Optional> *start_value;    // 后台预设已购数量
@property (nonatomic, copy) NSString<Optional> *seller_name;    // 商户名称
@property (nonatomic, copy) NSString<Optional> *remain_time;    // 剩余时间
@property (nonatomic, copy) NSString<Optional> *state;          // 活动状态(1=>未开始 2=>进行中 3=>已结束（成功）4=>已结束，待处理 5=>已结束（失败）)

@property (nonatomic, copy) NSString<Optional> *passTime;       // 已流逝的时间:秒数<额外增加字段>

@end
