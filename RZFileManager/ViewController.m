//
//  ViewController.m
//  RZFileManager
//
//  Created by 若醉 on 2018/10/18.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "ViewController.h"
#import "RZFileDownloadManager.h"
#import "RZFIleManageViewController.h"

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
    
    [self btnWithFrame:CGRectMake(0, 500, 300, 30) tag:5 title:@"进入文件管理"];
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
//        NSString *url = @"http://dl.paragon-software.com/demo/ntfsmac15_trial.dmg";
        NSString *url = @"https://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=tup&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&cs=1778162608,400941225&os=2403920503,1642650903&simid=3366844828,234338709&pn=18&rn=1&di=18811665290&ln=1751&fr=&fmq=1541384974401_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&is=0,0&istype=0&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&hs=2&objurl=http%3A%2F%2Fpic.666pic.com%2Fthumbs2%2F2081761%2F83311906%2Fapi_thumb_450.jpg&rpstart=0&rpnum=0&adpicid=0";
        self.manage = [[RZFileDownloadManager alloc] init];
        self.manage.fileName = @"image_2.jpg";
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
    } else if (sender.tag == 5) {
        [RZFIleManageViewController showFilesManagerFrom:self willSelected:^BOOL(RZFileDownloadManager *file) {
            return NO;
        } selected:^(BOOL isCancel, NSArray<RZFileDownloadManager *> *files) {
            
        } maxCount:3];
    }
}


@end

