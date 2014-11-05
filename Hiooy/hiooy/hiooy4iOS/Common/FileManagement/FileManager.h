//
//  FileManager.h
//  KKMYForU
//
//  Created by Zhiyong on 13-11-4.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (void)deleteFolder:(NSString *)folderName;
+ (float)folderSizeAtName:(NSString*)folderName;
+ (float)fileSizeForDir:(NSString*)path;

@end
