//
//  WebRequestModel.h
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//  网页发给平台层的请求

#import "JSONModel.h"

@interface WebRequestModel : JSONModel

@property (nonatomic, assign) int model;
@property (nonatomic, strong) NSString *handler;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSString *jsonData;

@end
