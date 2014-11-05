//
//  RemoteVersionModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "JSONModel.h"

@interface RemoteVersionModel : JSONModel

@property (nonatomic, assign) int resultCount;
@property (nonatomic, strong) NSArray *results;

@end
