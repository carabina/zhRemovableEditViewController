//
//  zhRemovableEditViewController.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhRemovableEditCollectionViewCell.h"

@interface zhRemovableEditViewLayout : NSObject

+ (instancetype)defaultLayout;

/// 每行显示多少个
@property (nonatomic, assign) NSInteger displayCount;

/// 设置每区section边距 (每个section的边缘留白 )
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/// 设置每区section的高度
@property (nonatomic, assign) CGFloat sectionHeight;

/// 水平方向上item之间的间距
@property (nonatomic, assign) CGFloat horizontalSpacing;

/// 竖直方向上item之间的间距
@property (nonatomic, assign) CGFloat verticalSpacing;

/// 通过设置的sizeScale可以得到item的高度 (item.height = item.width / sizeScale)
@property (nonatomic, assign) CGFloat sizeScale;

/// 获取水平方向上所有留白
@property (nonatomic, assign, readonly) CGFloat horizontalAllPadding;

@end

@interface zhRemovableEditViewController : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/// 数据源
@property (nonatomic, strong) NSMutableArray<zhRemovableEditSectionModel *> *dataArray;

/// 布局信息
@property (nonatomic, strong) zhRemovableEditViewLayout *reLayout;

/// 自定义图片信息
@property (nonatomic, strong) zhRemovableEditSetImages *reImages;

/// 是否显示预留区域
@property (nonatomic, assign) BOOL showReservezone;

/// 设置可拖动区域中前fixedCount个不可移动 (默认为0不限制)
@property (nonatomic, assign) NSInteger fixedCount;

/// 设置可拖动区域中最多显示的数量 (默认为0不限制)
@property (nonatomic, assign) NSInteger maxCount;

/// 重写该方法用于自定义设置
- (void)zh_commonConfiguration;

/// 重写该方法用于设置数据源
- (void)zh_loadData;

@end
