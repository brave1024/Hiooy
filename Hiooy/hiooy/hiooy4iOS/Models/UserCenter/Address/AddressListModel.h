//
//  AddressListModel.h
//  hiooy
//
//  Created by retain on 14-5-8.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  收货地址列表接口返回的数据实体

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface AddressListModel : JSONModel

@property (nonatomic, strong) NSArray<AddressModel, Optional> *receivers;

@end
