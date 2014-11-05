//
//  DocHelper.h
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//  沙盒doc操作

#import <Foundation/Foundation.h>

@interface DocHelper : NSObject

+ (NSString *)getAppDocDirectory;

+ (NSString *)getFilePathInDocDir:(NSString *)fileName;

+ (NSArray *)listDirInPath:(NSString *)dirName;

+ (void)createDirInPath:(NSString *)dirName;

+ (void)createFileInPath:(NSString *)fileName;

+ (NSString *)getFileNameFromPath:(NSString *)path;

+ (NSString *)getDatabasePathOfContacts;

+ (double)getVolumeOfContactsFile;



@end
