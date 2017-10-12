//
//  zhRemovableEditModel.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, zhRemovableEditBadgeState) {
    zhRemovableEditBadgeStateNormal = 0,    // 正常状态(无任何标记)
    zhRemovableEditBadgeStateAddible,       // 可添加状态
    zhRemovableEditBadgeStateDeletable,     // 可删减状态
    zhRemovableEditBadgeStateSelected,      // 已选状态(不可操作)
};

@interface zhRemovableEditItemModel : NSObject <NSCopying>

/// 通过`+ modelWithUniqueId`方法初始化并设置uniqueId
+ (instancetype)modelWithUniqueId:(NSInteger)uniqueId;

/// 唯一标识
@property (nonatomic, assign, readonly) NSInteger uniqueId; // Unique identifier

/// 文本标题
@property (nonatomic, strong) NSString *title;

/// 图标iconUrl (如果iconUrl为空，则使用iconName)
@property (nonatomic, strong) NSString *iconUrl;

/// 图标名称
@property (nonatomic, strong) NSString *iconName;

/// 用于标记item处于哪种编辑状态 (0正常状态 1可添加状态 2可删减状态 3已选状态)
@property (nonatomic, assign) zhRemovableEditBadgeState badgeState;

/// 可以重写该方法对字段重命名
- (NSDictionary<NSString *,NSString *> *)zh_renameKeys;

@end

@interface zhRemovableEditGroupModel : NSObject <NSCopying>

/// 分组的文本标题
@property (nonatomic, strong) NSString *groupTitle;

/// 分组副文本标题
@property (nonatomic, strong) NSString *groupSubTitle;

/// 每组的item数据模型数组
@property (nonatomic, strong) NSMutableArray<zhRemovableEditItemModel *> *groupItems;

/// 分组的富文本标题(如果attributedText为空，则使用text)
@property (nonatomic, strong) NSAttributedString *attributedTitle;

/// 数据源映射
+ (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data;

/// 重写该方法设置groupItems对应的模型类
- (Class)zh_groupItemsSubclass;

/// 可以重写该方法对字段重命名
- (NSDictionary<NSString *,NSString *> *)zh_renameKeys;

@end
