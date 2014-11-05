//
//  AddressItemModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  添加的收货地址实体...<用于网络请求时拼装的本地收货地址实体,便于传参>

#import "JSONModel.h"

@interface AddressItemModel : JSONModel

@property (nonatomic, strong) NSString *name;           // 用户姓名
@property (nonatomic, strong) NSString *area_id;        // 区域id
@property (nonatomic, strong) NSString *addr;           // 地址详情
@property (nonatomic, strong) NSString *zipcode;        // 邮编
@property (nonatomic, strong) NSString *telephone;      // phone
@property (nonatomic, strong) NSString *mobile;         // phone
@property (nonatomic, strong) NSString *is_default;     // 是否为默认 0:非默认 1:默认

@property (nonatomic, strong) NSString<Optional> *addr_id;  // 用于修改地址~!@

@end
