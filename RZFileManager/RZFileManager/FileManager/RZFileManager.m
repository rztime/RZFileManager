//
//  RZFileManager.m
//  RZFileManager
//
//  Created by 若醉 on 2018/10/23.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "RZFileManager.h"

NSString * const RZRelativeFileDirectory = @"/tmp/RZFileDirectory/";

@implementation RZFileManager
/**
 检查文件夹中是否已经有了此文件，如果有，则改名避免被覆盖
 
 @param fileName 默认名字
 @return 名字
 */
+ (NSString *)checkFileName:(NSString *)fileName {
    NSInteger index = 1;
    NSString *tempName = fileName;
    
    NSMutableArray *fileFlag = [fileName componentsSeparatedByString:@"."].mutableCopy;
    
    while ([self hasFile:tempName]) {
        if (fileFlag.count == 2) {
            NSString *name = [[fileFlag firstObject] stringByAppendingFormat:@"%ld", index];
            tempName = [@[name, fileFlag[1]] componentsJoinedByString:@"."];
        } else {
            tempName = [fileFlag.firstObject stringByAppendingFormat:@"%ld", index];
        }
        index++;
    }
    return tempName;
}

+ (BOOL)hasFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:RZRelativeFileDirectory] stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)deleteFile:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}
@end
