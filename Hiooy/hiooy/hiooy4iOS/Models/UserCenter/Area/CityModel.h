//
//  CityModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  城市实体

#import <Foundation/Foundation.h>
#import "AreaModel.h"

@protocol CityModel <NSObject>

@end

@interface CityModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<AreaModel, Optional> *districts;

@end
