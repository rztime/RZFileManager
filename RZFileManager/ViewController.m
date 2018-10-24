//
//  ViewController.m
//  RZFileManager
//
//  Created by 若醉 on 2018/10/18.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "ViewController.h"
#import "RZFileDownloadManager.h"
@interface ViewController ()

@property (nonatomic, strong) RZFileDownloadManager *manage;

@property (nonatomic, strong) NSMutableArray <RZFileDownloadManager *> *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self btnWithFrame:CGRectMake(0, 100, 300, 30) tag:0 title:@"下载"];
    [self btnWithFrame:CGRectMake(0, 150, 300, 30) tag:1 title:@"取消下载"];
    
    [self btnWithFrame:CGRectMake(0, 300, 300, 30) tag:3 title:@"获取所有的数据"];
    [self btnWithFrame:CGRectMake(0, 350, 300, 30) tag:4 title:@"删除数据"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)btnWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = frame;
    btn.backgroundColor = [UIColor redColor];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        // Do any additional setup after loading the view, typically from a nib.
        NSString *url = @"http://dl.paragon-software.com/demo/ntfsmac15_trial.dmg";
        self.manage = [[RZFileDownloadManager alloc] init];
        self.manage.fileName = @"hhhhh.dmg";
        [self.manage downloadWithURL:url];
        self.manage.preogress = ^(CGFloat fileSize, CGFloat progress) {
            NSLog(@"fileSize:%lf progress:%lf", fileSize, progress);
        };
        self.manage.downloadComplete = ^(NSError *error, NSString *filePath, NSString *relativeFilePath) {
            NSLog(@"filePath:%@\n\n", filePath);
        };
    } else if (sender.tag == 1) {
        [self.manage cancel];
    } else if (sender.tag == 3) {
        self.array = [RZFileDownloadManager rz_queryAllDownloadFiles].mutableCopy;
    } else if (sender.tag == 4) {
        [self.array enumerateObjectsUsingBlock:^(RZFileDownloadManager * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj deleteFromCache];
        }];
    }
}


@end

