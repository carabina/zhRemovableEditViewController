//
//  zhRemovableEditModel.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, zhRemovableEditBadgeState) {
    zhRemovableEditBadgeStateAddible = 0,   // 可加状态
    zhRemovableEditBadgeStateDeletable,     // 可减状态
    zhRemovableEditBadgeStateSelected,      // 已选状态(不可操作)
    zhRemovableEditBadgeStateNormal         // 正常状态(无任何标记)
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

/// 用于标记item处于哪种编辑状态 (0加状态 1减状态 2已选状态 3无)
@property (nonatomic, assign) zhRemovableEditBadgeState badgeState;

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

/// 数据源映射 (可对字段重命名)
+ (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data
                                                  renameKeys:(NSDictionary<NSString *, NSString *> *)renameKeys;

@end
