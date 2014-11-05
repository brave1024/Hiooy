//
//  CartResponseAddressModel.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  提交购物车接口返回数据中的地址实体...<响应>

#import "JSONModel.h"

@protocol CartResponseAddressModel <NSObject>

@end

@interface CartResponseAddressModel : JSONModel

@property (nonatomic, copy) NSString *addr_id;                  // 地址id
@property (nonatomic, copy) NSString *address;                  // 地址
@property (nonatomic, copy) NSString *mobile;                   // 手机
@property (nonatomic, copy) NSString<Optional> *telephone;      // 座机
@property (nonatomic, copy) NSString *name;                     // 姓名
@property (nonatomic, copy) NSString<Optional> *choosed;        // 是否被选中 true

@end
