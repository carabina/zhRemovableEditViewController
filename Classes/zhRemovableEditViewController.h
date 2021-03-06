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
@property (nonatomic, strong) NSMutableArray<zhRemovableEditGroupModel *> *dataArray;

/// 布局信息
@property (nonatomic, strong) zhRemovableEditViewLayout *reLayout;

/// 自定义图片信息
@property (nonatomic, strong) zhRemovableEditSetImages *reImages;

/// 是否显示预留区域
@property (nonatomic, assign) BOOL showReservezone;

/// 使用弹性动画
@property (nonatomic, assign) BOOL useSpringAnimation;

/// 是否处于可编辑状态
@property (nonatomic, assign, readonly) BOOL isEditable;

/// 设置可拖动区域中前fixedCount个不可移动 (默认为0不限制)
@property (nonatomic, assign) NSInteger fixedCount;

/// 设置可拖动区域中最多显示的数量 (默认为0不限制)
@property (nonatomic, assign) NSInteger maxCount;

/// 重写该方法自定义点击事件
- (void)zh_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/// 重写该方法可自定义添加已超出最大数量时的操作
- (void)zh_removableEditCollectionViewCellMoreThanMaxCount:(zhRemovableEditCollectionViewCell *)cell;

/// 重写该方法可用于编辑完成后做保存操作
- (void)zh_removableEditCollectionViewCellWorkCompleted:(zhRemovableEditCollectionViewCell *)cell;

/// 使用该方法刷新页面数据
- (void)zh_reloadData;

/// 进入编辑模式
- (void)zh_enteringEditMode;

/// 关闭编辑模式
- (void)zh_closeEditMode;

@end
