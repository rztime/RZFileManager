//
//  RZFIleManageViewController.m
//  RZFileManager
//
//  Created by Admin on 2018/11/1.
//  Copyright © 2018 rztime. All rights reserved.
//

#import "RZFIleManageViewController.h"
#import "RZFileDownloadManager.h"
#import "RZFileManager.h"

@interface RZFIleManageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *nav;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void(^finish)(BOOL isCancel, NSArray <RZFileDownloadManager *> * files);
@property (nonatomic, copy) BOOL(^willSelected)(RZFileDownloadManager * file);

@property (nonatomic, strong) NSMutableArray <RZFileDownloadManager *> *files;

@property (nonatomic, strong) NSMutableArray <RZFileDownloadManager *> *selectedFiles;
@property (nonatomic, assign) NSInteger maxCount;
@end

@implementation RZFIleManageViewController

+ (void)showFilesManagerFrom:(UIViewController *)target {
    [self showFilesManagerFrom:target selected:nil maxCount:0];
}
+ (void)showFilesManagerFrom:(UIViewController *)target selected:(void(^)(BOOL isCancel, NSArray <RZFileDownloadManager *>* files))selectedIfNeed maxCount:(NSInteger)count {
    [self showFilesManagerFrom:target willSelected:nil selected:selectedIfNeed maxCount:count];
}
+ (void)showFilesManagerFrom:(UIViewController *)target willSelected:(BOOL(^)(RZFileDownloadManager *file))willSelected selected:(void(^)(BOOL isCancel, NSArray <RZFileDownloadManager *>* files))selectedIfNeed maxCount:(NSInteger)count {
    RZFIleManageViewController *vc = [[RZFIleManageViewController alloc] init];
    vc.finish = selectedIfNeed;
    vc.maxCount = count;
    vc.willSelected = willSelected;
    [target presentViewController:vc animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self nav];
    self.selectedFiles = [NSMutableArray new];
    self.files = [NSMutableArray new];
    NSMutableArray *files = [RZFileDownloadManager rz_queryAllDownloadFiles].mutableCopy;
    for (NSInteger i = files.count-1; i >= 0; i--) {
        RZFileDownloadManager *file = files[i];
        [self.files addObject:file];
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nav.frame), UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - CGRectGetMaxY(self.nav.frame))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self titleStringRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
}
// 是否是iPhone X
#define rzkiPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
// 是否是iPhone XR
#define rzkiPhoneXR (CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

// 刘海屏
#define rzkiPhoneLiuHai (rzkiPhoneX || rzkiPhoneXR)

- (UIView *)nav {
    if (!_nav) {
        CGFloat height = rzkiPhoneLiuHai? 88: 64;
        _nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
        _nav.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_nav];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nav addSubview:btn];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(10, height - 44, 44, 44);
        [btn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        [_nav addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"文件管理器";
        label.frame = CGRectMake((_nav.frame.size.width - 150)/2, height - 44, 150, 44);
        self.titleLabel = label;
        
        if (self.finish) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nav addSubview:btn];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.frame = CGRectMake(_nav.frame.size.width - 10 - 44, height - 44, 44, 44);
            [btn addTarget:self action:@selector(selectedFinish) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _nav;
}

- (void)titleStringRefresh {
    if (self.finish) {
        self.titleLabel.text = [NSString stringWithFormat:@"文件管理器(%ld/%ld)", self.selectedFiles.count, self.maxCount];
    } else {
        self.titleLabel.text = @"文件管理器";
    }
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.finish) {
            self.finish(YES, nil);
        }
    }];
}

- (void)selectedFinish {
    if (self.selectedFiles.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还未选择文件" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.finish) {
            self.finish(NO, self.selectedFiles.copy);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:self.finish? UITableViewCellStyleSubtitle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        if (self.finish) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RZFileManagerFileSource.bundle/未选择"]];
            cell.accessoryView = imageView;
        }
    }
    RZFileDownloadManager *file = self.files[indexPath.row];
    
    if (self.finish) {
        UIImageView *imageView = (UIImageView *)cell.accessoryView;
        imageView.image = [self.selectedFiles containsObject:file]? [UIImage imageNamed:@"RZFileManagerFileSource.bundle/选择"] : [UIImage imageNamed:@"RZFileManagerFileSource.bundle/未选择"];
    }
    
    cell.textLabel.text = file.fileName;
    cell.detailTextLabel.text = [self fileSzieString:file.size];
    cell.imageView.image = [RZFileManager imageByType:file.fileName.pathExtension];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        RZFileDownloadManager *file = weakSelf.files[indexPath.row];
        [file deleteFromCache];
        [weakSelf.selectedFiles removeObject:file];
        [weakSelf.files removeObject:file];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    return @[action];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RZFileDownloadManager *file = self.files[indexPath.row];
    BOOL flag = YES;
    if (self.willSelected) {
        flag = self.willSelected(file);
    }

    if (self.finish && flag) {
        
        if ([self.selectedFiles containsObject:file]) {
            [self.selectedFiles removeObject:file];
        } else {
            if (self.selectedFiles.count >= self.maxCount) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多选择%ld个文件", self.maxCount] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [self.selectedFiles addObject:file];
        }
        [tableView reloadData];
        [self titleStringRefresh];
    }
}

- (NSString *)fileSzieString:(double)size {
    if (size <= 0) {
        return @"0B";
    }
    if (size < 1024) {
        NSString * xx = [NSString stringWithFormat:@"%.2f", size];
        return [NSString stringWithFormat:@"%@B", @(xx.floatValue)];
    }
    if (size < 1048576) {
        NSString * xx = [NSString stringWithFormat:@"%.2f", size/1024.f];
        return [NSString stringWithFormat:@"%@K", @(xx.floatValue)];
    }
    if (size < 1073741824) {
        NSString * xx = [NSString stringWithFormat:@"%.2f", size/1048576.f];
        return [NSString stringWithFormat:@"%@M", @(xx.floatValue)];
    }
    NSString * xx = [NSString stringWithFormat:@"%.2f", size/1073741824];
    return [NSString stringWithFormat:@"%@G", @(xx.floatValue)];
}

@end
