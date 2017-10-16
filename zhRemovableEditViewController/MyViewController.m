//
//  MyViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/29.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyViewController.h"
#import "MyModel.h"

#define zh_ThemeColor [UIColor colorWithRed:18 / 255. green:150 / 255. blue:219 / 255. alpha:1]

static NSString *zh_storageFile = @"zh_Test.plist";

@interface MyViewController ()

@property (nonatomic, strong) UIButton *navRightButton;
@property (nonatomic, strong) UIButton *navLeftButton;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationInitialization];
    [self initialConfiguration];
    [self loadData];
}

- (void)navigationInitialization {
    self.navigationItem.title = @"全部应用";
    NSDictionary *titleAttri = @{NSFontAttributeName : [UIFont systemFontOfSize:zh_fontSizeFit(18)],
                                 NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttri];
    
    self.navigationController.navigationBar.tintColor = zh_ThemeColor; // 改变导航栏返回按钮颜色
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
}

- (void)rightButtonItemClicked:(UIButton *)sender {
    [self changeState:NO];
}

- (void)leftButtonItemClicked:(UIButton *)sender {
    [self changeState:YES];
}

- (void)changeState:(BOOL)isCanael {
    if (self.isEditable) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = @"全部应用";
        [_navRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self zh_closeEditMode];
        if (!isCanael) {
            [self writeData];
        }
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftButton];
        UIColor *themeColor = [UIColor colorWithRed:18 / 255. green:150 / 255. blue:219 / 255. alpha:1];
        [self.navLeftButton setTitleColor:themeColor forState:UIControlStateNormal];
        self.navigationItem.title = @"我的应用编辑";
        [_navRightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self zh_enteringEditMode];
    }
    [self loadData];
}

- (void)initialConfiguration {
    zhRemovableEditSetImages *images = [[zhRemovableEditSetImages alloc] init];
    images.reservezoneImage = [UIImage imageNamed:@"zh_REImaginarylineBox"];
    images.badgeAddImage = [UIImage imageNamed:@"zh_REBadgeAdd"];
    images.badgeDeleteImage = [UIImage imageNamed:@"zh_REBadgeDelete"];
    images.badgeSelectedImage = [UIImage imageNamed:@"zh_REBadgeDone"];
    self.reImages = images;
    self.useSpringAnimation = NO;
    self.showReservezone = YES;
    self.fixedCount = 4;
    self.maxCount = 8;
}

- (void)loadData {
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

#pragma mark - Overwrite

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
    NSDictionary *storageDict = @{@"Group" : dictArray};
    BOOL re = [storageDict writeToFile:path atomically:YES];
    if (re) NSLog(@"write yes");
}

#pragma mark - Lazy

- (UIButton *)navRightButton {
    if (!_navRightButton) {
        _navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        _navRightButton.frame = CGRectMake(0, 0, 40, 30);
        _navRightButton.titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(16)];
        [_navRightButton setTitleColor:zh_ThemeColor forState:UIControlStateNormal];
        [_navRightButton addTarget:self action:@selector(rightButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightButton;
}

- (UIButton *)navLeftButton {
    if (!_navLeftButton) {
        _navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navLeftButton.frame = CGRectMake(0, 0, 40, 30);
        _navLeftButton.titleLabel.font = [UIFont systemFontOfSize:zh_fontSizeFit(16)];
        [_navLeftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navLeftButton setTitleColor:zh_ThemeColor forState:UIControlStateNormal];
        [_navLeftButton addTarget:self action:@selector(leftButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navLeftButton;
}

@end

