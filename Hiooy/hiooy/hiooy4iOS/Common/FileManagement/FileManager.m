//
//  FileManager.m
//  KKMYForU
//
//  Created by Zhiyong on 13-11-4.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

/**************************************************
 函数描述：删除文件夹
 调用函数：无
 被调用函数：无
 输入参数：(NSString *)FolderName
 输出参数：无
 返回值：无
 *************************************************/
+ (void)deleteFolder:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    
    if ([fileManager fileExistsAtPath:folderPath])//删除文件夹
    {
        [fileManager removeItemAtPath:folderPath error:nil];
    }
}


+ (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (float )folderSizeAtName:(NSString*) folderName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 计算文件夹下文件的总大小
+ (float)fileSizeForDir:(NSString*)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    float size =0;
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic = [fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/1024.0/1024.0;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
        
    return size;
}

@end
