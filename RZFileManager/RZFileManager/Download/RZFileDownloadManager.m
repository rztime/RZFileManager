//
//  RZFileDownloadManager.m
//  RZFileManager
//
//  Created by 若醉 on 2018/10/18.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "RZFileDownloadManager.h"
#import <AFNetworking/AFNetworking.h>
#import "RZFileManager.h"
#import <RZFMDB/NSObject+RZFMDBHelper.h>

#define RZFileDirecotory [NSHomeDirectory() stringByAppendingString:RZRelativeFileDirectory]

@interface RZFileDownloadManager () {
    NSURLSessionDownloadTask *task;
}
@end

@implementation RZFileDownloadManager

+ (void)load {
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *filePath = RZFileDirecotory;
    if(![manage isExecutableFileAtPath:filePath]) {
        [manage createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    [self rz_createdDBTable];
}

+ (NSMutableArray<NSString *> *)rz_tableInsertIgnoreColumns {
    return @[@"preogress", @"downloadComplete", ].mutableCopy;
}

- (void)rz_willInsertOrUpdaate {
    self.updateTime = [NSDate new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.creatTime = [NSDate new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appKilled:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)appKilled:(id)sender {
    [self cancel];
}

- (void)downloadWithURL:(NSString *)url {
    _downloadURL = url;
    
    [self rz_insertDataToDBTable];
    
    [self reDownLoad];
}

- (NSString *)fileName {
    if (_fileName.length == 0) {
        _fileName = [self.downloadURL lastPathComponent];
    }
    return _fileName;
}

- (NSString *)relativeLocalFilePath {
    if(_relativeLocalFilePath.length == 0) {
        _relativeLocalFilePath = [RZRelativeFileDirectory stringByAppendingPathComponent:self.fileName];
    }
    return _relativeLocalFilePath;
}

/**
 本地全路径
 
 @return <#return value description#>
 */
- (NSString *)localFilePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:self.relativeLocalFilePath];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)reDownLoad {
    //远程地址
    NSURL *URL = [NSURL URLWithString:self.downloadURL];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    __weak typeof(self) weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self->task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        weakSelf.size = downloadProgress.totalUnitCount;
        weakSelf.progress = downloadProgress.fractionCompleted;
        weakSelf.status = RZFileDownloadStatus_ing;
        [weakSelf rz_updateDataToDBTable];
        
        if (weakSelf.preogress) {
            weakSelf.preogress(downloadProgress.totalUnitCount, downloadProgress.fractionCompleted);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:weakSelf.localFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            weakSelf.status = RZFileDownloadStatus_fail;
            NSLog(@"error:%@ %@", error.domain, error.userInfo);
        } else {
            weakSelf.status = RZFileDownloadStatus_success;
        }
        [weakSelf rz_updateDataToDBTable];
        
        if (weakSelf.downloadComplete) {
            weakSelf.downloadComplete(error, weakSelf.localFilePath, weakSelf.relativeLocalFilePath);
        }
    }];
    [self->task resume];
}

/**
 取消
 */
- (void)cancel {
    [self->task cancel];
}
- (BOOL)deleteFromCache {
    [RZFileManager deleteFile:self.localFilePath];
    return [self rz_deleteDataFromDBTable];
}

/**
 查询得到数据库中已经存在的下载的内容
 
 @return <#return value description#>
 */
+ (NSArray <RZFileDownloadManager *> *)rz_queryAllDownloadFiles {
    return [RZFileDownloadManager rz_queryDataFromDBTable];
}
@end
