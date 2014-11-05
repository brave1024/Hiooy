//
//  WebResultModel.h
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//

#import "JSONModel.h"

@interface WebResultModel : JSONModel

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *data;

@end
