//
//  DocHelper.m
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "DocHelper.h"

@implementation DocHelper


+ (NSString *)getAppDocDirectory {
    
    //return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
    
}

+ (NSString *)getFilePathInDocDir:(NSString *)fileName {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	if (fileName == nil) {
		return docDir;
	}
	return [docDir stringByAppendingPathComponent:fileName];
    
}

+ (NSArray *)listDirInPath:(NSString *)dirName {
    
    NSLog(@"path:%@", dirName);
    NSError *err;
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirName error:&err];
    
}

+ (void)createDirInPath:(NSString *)dirName {
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dirName attributes:nil];
    
}

+ (void)createFileInPath:(NSString *)fileName {
    
    [[NSFileManager defaultManager] createFileAtPath:fileName contents:[@"hello world...!@" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
} 

+ (NSString *)getFileNameFromPath:(NSString *)path {
    
    if (path == nil || [path isEqualToString:@""] == YES) {
        return nil;
    }
    
    NSArray *pathArr = [path componentsSeparatedByString:@"/"];
    if (pathArr.count <= 1) {
        return nil;
    }
    
    NSString *str = [pathArr lastObject];
    if (str == nil || [str isEqualToString:@""] == YES) {
        return nil;
    }
    
    return str;
    
}

+ (NSString *)getDatabasePathOfContacts {
    
    NSString *docPath = [DocHelper getAppDocDirectory];
    NSString *contactsPath = [docPath stringByAppendingPathComponent:kDatabase];
    return contactsPath;
    
}


+ (double)getVolumeOfContactsFile {
    
    NSString *dbPath = [self getDatabasePathOfContacts];
    NSError *err;
    NSDictionary *itemDic = [[NSFileManager defaultManager] attributesOfItemAtPath:dbPath error:&err];
    if (itemDic == nil) {
        NSLog(@"error:%@", [err debugDescription]);
        return 0.0;
    }else {
        NSNumber *fileSize = [itemDic objectForKey:NSFileSize];
        return [fileSize doubleValue];
    }
    
}


@end
