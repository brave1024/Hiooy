//
//  CartResponseShippingModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  提交购物车接口返回数据中的配送方式实体...<响应>

#import "JSONModel.h"

@protocol CartResponseShippingModel <NSObject>

@end

@interface CartResponseShippingModel : JSONModel

@property (nonatomic, copy) NSString *dt_id;                // 配送方式id
@property (nonatomic, copy) NSString *dt_name;              // 配送方式名称
@property (nonatomic, copy) NSString *money;                // 金额
@property (nonatomic, copy) NSString<Optional> *choosed;    // 是否被选中

@end
