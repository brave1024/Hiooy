//
//  CountryModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  全国省市区数据实体

#import <Foundation/Foundation.h>
#import "ProvinceModel.h"

@interface CountryModel : JSONModel

@property (nonatomic, strong) NSArray<ProvinceModel> *provinces;

@end
