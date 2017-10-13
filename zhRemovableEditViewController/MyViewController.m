//
//  MyViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/29.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyViewController.h"
#import "MyModel.h"

@interface MyViewController ()

@property (nonatomic, assign) BOOL inEditing;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationInitialization];
}

- (void)navigationInitialization {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)rightButtonItemClicked:(UIBarButtonItem *)sender {
    [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
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
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"MyData" ofType:@"json"];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:NSJSONReadingAllowFragments error:nil];
    NSArray *responseData = [jsonObject objectForKey:@"Group"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<zhRemovableEditGroupModel *> *models = [MyGroupModel mapWithData:responseData];
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

@end
