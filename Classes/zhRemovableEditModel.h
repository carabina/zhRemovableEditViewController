//
//  zhRemovableEditModel.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, zhRemovableEditBadgeState) {
    zhRemovableEditBadgeStatePlus = 0,
    zhRemovableEditBadgeStateMinus,
    zhRemovableEditBadgeStateGray,
    zhRemovableEditBadgeStateNone
};

@interface zhRemovableEditItemModel : NSObject <NSCopying>

/// 通过`+ modelWithUniqueId`方法初始化并设置uniqueId
+ (instancetype)modelWithUniqueId:(NSInteger)uniqueId;

/// 唯一标识
@property (nonatomic, assign, readonly) NSInteger uniqueId; // Unique identifier

/// 文本标题
@property (nonatomic, strong) NSString *title;

/// 图片image
@property (nonatomic, strong) UIImage *image;

/// 图片imageUrl (如果imageUrl为空，则使用image显示)
@property (nonatomic, strong) UIImage *imageUrl;

/// 用于标记item处于哪种编辑状态
@property (nonatomic, assign) zhRemovableEditBadgeState badgeState;

@end

@interface zhRemovableEditSectionModel : NSObject <NSCopying>

/// 分组的文本标题
@property (nonatomic, strong) NSString *title;

/// 分组的富文本标题(如果attributedText为空，则使用text)
@property (nonatomic, strong) NSAttributedString *attributedTitle;

/// 每组的item数据模型数组
@property (nonatomic, strong) NSMutableArray<zhRemovableEditItemModel *> *itemModels;

@end
