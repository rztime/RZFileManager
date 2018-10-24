//
//  RZFileDownloadManager.h
//  RZFileManager
//
//  Created by 若醉 on 2018/10/18.
//  Copyright © 2018 rztime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 


typedef void(^RZDownloadProgress) (CGFloat fileSize, CGFloat progress);

typedef void(^RZDownloadComplete) (NSError *error, NSString *filePath, NSString *relativeFilePath);

typedef NS_ENUM(NSInteger, RZFileDownloadStatus) {
    RZFileDownloadStatusDefault = 0,
    RZFileDownloadStatus_ing = 1, // 进行中
    RZFileDownloadStatus_fail = 2, // 失败
    RZFileDownloadStatus_success = 3, // 成功
};


@interface RZFileDownloadManager : NSObject

@property (nonatomic, assign) NSInteger rID;
// 进度
@property (nonatomic, assign) CGFloat progress;
// 文件size
@property (nonatomic, assign) double size;
// 文件状态
@property (nonatomic, assign) RZFileDownloadStatus status;
// 文件名字
@property (nonatomic, copy) NSString *fileName;
// 本地（相对）地址
@property (nonatomic, copy) NSString *relativeLocalFilePath;
// 服务器下载地址
@property (nonatomic, copy) NSString *downloadURL;
// 下载时间
@property (nonatomic, strong) NSDate *creatTime;
// 更新时间
@property (nonatomic, strong) NSDate *updateTime;
// 额外的参数，可以放在这里
@property (nonatomic, strong) NSDictionary *specialEXParams;

@property (nonatomic, copy) RZDownloadProgress preogress; // 进度

@property (nonatomic, copy) RZDownloadComplete downloadComplete; // 完成之后的回调

// 首次下载时，调用，请配置好fileName，如果没有fileName，则从url中获取文件名
- (void)downloadWithURL:(NSString *)url;

/**
 本地全路径

 @return <#return value description#>
 */
- (NSString *)localFilePath;

/**
 重新下载
 */
- (void)reDownLoad;

/**
  取消
 */
- (void)cancel;

/**
 删除，从文件夹中删除文件，并删除数据库的数据

 @return <#return value description#>
 */
- (BOOL)deleteFromCache;

/**
 查询得到数据库中已经存在的下载的内容

 @return <#return value description#>
 */
+ (NSArray <RZFileDownloadManager *> *)rz_queryAllDownloadFiles;
@end
