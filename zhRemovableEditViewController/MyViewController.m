//
//  MyViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/29.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyViewController.h"
#import "MyModel.h"

static NSString *zh_storageFile = @"zh_Test.plist";

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationInitialization];
}

- (void)navigationInitialization {
    self.navigationItem.title = @"我的应用编辑";
    NSDictionary *titleAttri = @{NSFontAttributeName : [UIFont systemFontOfSize:zh_fontSizeFit(18)],
                                 NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttri];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(17)];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)rightButtonItemClicked:(UIButton *)sender {
    if (self.isEditable) {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self zh_closeEditMode];
        [self writeData];
    } else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self zh_enteringEditMode];
    }
}

#pragma mark - Overwrite methods

- (void)zh_commonConfiguration {
    [super zh_commonConfiguration];
    self.showReservezone = YES;
    self.useSpringAnimation = NO;
    self.fixedCount = 4;
    self.maxCount = 8;
}

- (void)zh_loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *responseData = [self getData];
        if (!responseData) return ;
        NSArray *data = [responseData objectForKey:@"Group"];
        NSMutableArray<zhRemovableEditGroupModel *> *models = [MyGroupModel mapWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.dataArray = models;
            [self zh_reloadData];
        });
    });
}

-(void)zh_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MyGroupModel *gmodel = (MyGroupModel *)self.dataArray[indexPath.section];
    MyItemModel *imodel = (MyItemModel *)gmodel.groupItems[indexPath.row];
    NSLog(@"imodel.title==> %@", imodel.title);
}

- (void)zh_removableEditCollectionViewCellWorkCompleted:(zhRemovableEditCollectionViewCell *)cell {
    NSLog(@"操作完成~~~");
}

#pragma mark - Data

- (NSDictionary *)getData {
    // 读取沙盒存储内容
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentDir stringByAppendingPathComponent:zh_storageFile];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict) return dict;
    }
    // 首次读取mainBundle内容
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"MyData" ofType:@"json"];
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:NSJSONReadingAllowFragments error:nil];
}

- (void)writeData {
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"documentDir===> %@", documentDir);
    NSString *path = [documentDir stringByAppendingPathComponent:zh_storageFile];
    
    NSArray *dictArray = [MyGroupModel unmapWithArray:self.dataArray];
    NSLog(@"dictArray==> %@", dictArray);
    NSDictionary *storageDict = @{@"Group" : dictArray};
    BOOL re = [storageDict writeToFile:path atomically:YES];
    if (re) NSLog(@"write yes");
}

@end

