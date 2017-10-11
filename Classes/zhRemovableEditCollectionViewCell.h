//
//  zhRemovableEditCollectionViewCell.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zhRemovableEditModel.h"

static inline CGFloat zh_fontSizeFit(CGFloat value) {
    if ([UIScreen mainScreen].bounds.size.width < 375.0f) return value * 0.9;
    if ([UIScreen mainScreen].bounds.size.width > 375.0f) return value * 1.1;
    return value;
}

static inline CGFloat zh_sizeFitW(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.width / 375.0f);
}

static inline CGFloat zh_sizeFitH(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.height / 667.0f);
}

@interface zhRemovableEditSetImages : NSObject

+ (instancetype)defaultImages;
@property (nonatomic, strong) UIImage *reservezoneImage; // 设置预留区域虚线边框图片
@property (nonatomic, strong) UIImage *badgePlusImage;  // 加状态图片
@property (nonatomic, strong) UIImage *badgeMinusImage; // 减状态图片
@property (nonatomic, strong) UIImage *badgeGrayImage;  // 灰状态图片

@end

@class zhRemovableEditCollectionViewCell;
@protocol zhRemovableEditCollectionViewCellDelegate <NSObject>
@optional

/// 点击了cell上的右上方角标 (会触发新增item事件或删除item事件)
- (void)zh_removableEditCollectionViewCellDidClickBadge:(zhRemovableEditCollectionViewCell *)cell;

@end

@interface zhRemovableEditCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIImageView *badgeImageView;
@property (nonatomic, strong, readonly) UIImageView *reservezoneImageView; // default is hidden

@property (nonatomic, weak) id <zhRemovableEditCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) zhRemovableEditSetImages *images;
@property (nonatomic, strong) zhRemovableEditItemModel *model;

@end

@interface zhRemovableEditCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) zhRemovableEditSectionModel *sectionModel;

@end
