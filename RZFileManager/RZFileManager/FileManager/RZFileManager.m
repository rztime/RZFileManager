//
//  RZFileManager.m
//  RZFileManager
//
//  Created by 若醉 on 2018/10/23.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "RZFileManager.h"

#define rz_file_manager_nameBy(name) [UIImage imageNamed:[NSString stringWithFormat:@"RZFileManagerFileSource.bundle/%@", name]]

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

#pragma mark - 文件类型判断
+ (BOOL)isMusic:(NSString *)fileType {
    NSArray *types = @[@"mp3", @"MP3",
                       @"WAV", @"wav",
                       @"WMA", @"wma",
                       @"CD", @"cd",
                       @"APE", @"ape",
                       @"MIDI", @"midi",
                       @"RealAudio", @"REALAUDIO", @"realaudio",
                       @"VQF", @"vqf",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isVideo:(NSString *)fileType {
    NSArray *types = @[@"AVI", @"avi",
                       @"RMVB", @"rmvb",
                       @"RM", @"rm",
                       @"ASF", @"asf",
                       @"DIVX", @"divx",
                       @"MPG", @"mpg",
                       @"MPEG", @"mpeg",
                       @"WMV", @"wmv",
                       @"MP4", @"mp4",
                       @"MKV", @"mkv",
                       @"VOB", @"vob",
                       ];
    
    return [types containsObject:fileType];
}
+ (BOOL)isWord:(NSString *)fileType {
    NSArray *types = @[@"DOC", @"doc",
                       @"DOCX", @"docx",
                       @"DOCM", @"docm",
                       @"DOTX", @"dotx",
                       @"DOTM", @"dotm",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isExcel:(NSString *)fileType {
    NSArray *types = @[@"XLS", @"xls",
                       @"XLSX", @"xlsx",
                       @"XLSM", @"xlsm",
                       @"XLTX", @"xltx",
                       @"XLTM", @"xltm",
                       @"XLSB", @"xlsb",
                       @"XLAM", @"xlam",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isPPT:(NSString *)fileType {
    NSArray *types = @[@"PPT", @"ppt",
                       @"PPTX", @"pptx",
                       @"PPTM", @"pptm",
                       @"PPSX", @"ppsx",
                       @"PPTX", @"potx",
                       @"POTM", @"potm",
                       @"PPAM", @"ppam",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isPDF:(NSString *)fileType {
    NSArray *types = @[@"PDF", @"pdf"];
    
    return [types containsObject:fileType];
}

+ (BOOL)isTXT:(NSString *)fileType {
    NSArray *types = @[@"TXT", @"txt",
                       @"HTM", @"htm",
                       @"ASP", @"asp",
                       @"BAT", @"bat",
                       @"C", @"c",
                       @"BAS", @"bas",
                       @"PRG", @"prg",
                       @"CMD", @"cmd",
                       @"LOG", @"log",
                       @"RTF", @"rtf",
                       ];
    
    return [types containsObject:fileType];
}


+ (BOOL)isZip:(NSString *)fileType {
    NSArray *types = @[@"ZIP", @"zip",
                       @"RAR", @"rar",
                       @"7Z", @"7z",
                       @"CAB", @"cab",
                       @"ISO", @"iso",
                       ];
    
    return [types containsObject:fileType];
}

+ (BOOL)isImage:(NSString *)fileType {
    NSArray *types = @[@"BMP", @"bmp",
                       @"JPG", @"jpg",
                       @"PNG", @"png",
                       @"TIFF", @"tiff",
                       @"GIF", @"gif",
                       @"PCX", @"pcx",
                       @"TGA", @"tga",
                       @"EXIF", @"exif",
                       @"FPX", @"fpx",
                       @"SVG", @"svg",
                       @"PSD", @"psd",
                       @"CDR", @"cdr",
                       @"PCD", @"pcd",
                       @"DXF", @"dxf",
                       @"UFO", @"ufo",
                       @"EPS", @"eps",
                       @"AI", @"ai",
                       @"RAW", @"raw",
                       @"WMF", @"WMF",
                       @"WEBP", @"webp",
                       ];
    
    return [types containsObject:fileType];
}

+ (UIImage *)imageByType:(NSString *)fileType {
    if ([self isMusic:fileType]) {
        return rz_file_manager_nameBy(@"音频");
    }
    if ([self isVideo:fileType]) {
        return rz_file_manager_nameBy(@"视频");
    }
    if ([self isWord:fileType]) {
        return rz_file_manager_nameBy(@"word");
    }
    if ([self isExcel:fileType]) {
        return rz_file_manager_nameBy(@"excel");
    }
    if ([self isPPT:fileType]) {
        return rz_file_manager_nameBy(@"PPT");
    }
    if ([self isPDF:fileType]) {
        return rz_file_manager_nameBy(@"PDF");
    }
    if ([self isTXT:fileType]) {
        return rz_file_manager_nameBy(@"txt");
    }
    if ([self isZip:fileType]) {
        return rz_file_manager_nameBy(@"压缩包");
    }
    if ([self isImage:fileType]) {
        return rz_file_manager_nameBy(@"图片");
    }
    return rz_file_manager_nameBy(@"未知类型");
}
@end
