//
//  ProvinceModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  省份实体

#import <Foundation/Foundation.h>
#import "CityModel.h"

@protocol ProvinceModel <NSObject>

@end

@interface ProvinceModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<CityModel, Optional> *cities;

@end
