//
//  RZFIleManageViewController.h
//  RZFileManager
//
//  Created by Admin on 2018/11/1.
//  Copyright © 2018 rztime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFileDownloadManager.h"

@interface RZFIleManageViewController : UIViewController

+ (void)showFilesManagerFrom:(UIViewController *)target;

+ (void)showFilesManagerFrom:(UIViewController *)target selected:(void(^)(BOOL isCancel, NSArray <RZFileDownloadManager *>* files))selectedIfNeed maxCount:(NSInteger)count;

+ (void)showFilesManagerFrom:(UIViewController *)target willSelected:(BOOL(^)(RZFileDownloadManager *file))willSelected selected:(void(^)(BOOL isCancel, NSArray <RZFileDownloadManager *>* files))selectedIfNeed maxCount:(NSInteger)count;
@end
