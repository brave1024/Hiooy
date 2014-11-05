//
//  ServerAction.m
//  KKMYForM
//
//  Created by 黄磊 on 13-11-12.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "ServerAction.h"

static ServerAction *serverAction = nil;

@implementation ServerAction

+ (ServerAction *)shareInstant
{
    if (serverAction == nil)
    {
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"serverAction.plist"];
        serverAction = [[ServerAction alloc] initWithContentsOfFile:filePath];
    }
    return serverAction;
}

@end
