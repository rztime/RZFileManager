//
//  RZFileManager.h
//  RZFileManager
//
//  Created by 若醉 on 2018/10/23.
//  Copyright © 2018 rztime. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const RZRelativeFileDirectory;

@interface RZFileManager : NSObject

/**
 检查文件夹中是否已经有了此文件，如果有，则改名避免被覆盖

 @param fileName 默认名字
 @return 名字
 */
+ (NSString *)checkFileName:(NSString *)fileName;

+ (BOOL)hasFile:(NSString *)fileName;

+ (BOOL)deleteFile:(NSString *)filePath;
@end
