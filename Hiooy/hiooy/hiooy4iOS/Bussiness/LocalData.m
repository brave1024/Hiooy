//
//  LocalData.m
//  KKMYForM
//
//  Created by 黄磊 on 13-11-7.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "LocalData.h"

static LocalData *localData = nil;

@implementation LocalData

+ (LocalData *)shareInstant
{
    if (localData == nil)
    {
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LocalData.plist"];
        localData = [[LocalData alloc] initWithContentsOfFile:filePath];
    }
    return localData;
}

@end
