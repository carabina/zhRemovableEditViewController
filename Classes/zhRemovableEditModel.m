//
//  zhRemovableEditModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditModel.h"

@interface zhRemovableEditItemModel ()

@property (nonatomic, assign) NSInteger markId;
@property (nonatomic, assign) BOOL zh_usingReservezone;
@property (nonatomic, assign) BOOL zh_isInvisible;

@end

@implementation zhRemovableEditItemModel

+ (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    return [[self alloc] modelWithUniqueId:uniqueId];
}

- (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    model.markId = uniqueId;
    model.zh_usingReservezone = NO;
    model.zh_isInvisible = NO;
    return model;
}

- (NSInteger)uniqueId {
    return self.markId;
}

- (id)copyWithZone:(NSZone *)zone {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    model.markId = self.uniqueId;
    model.title = self.title;
    model.image = self.image;
    model.imageUrl = self.imageUrl;
    model.badgeState = self.badgeState;
    model.zh_usingReservezone = self.zh_usingReservezone;
    model.zh_isInvisible = self.zh_isInvisible;
    return model;
}

@end

@implementation zhRemovableEditSectionModel

- (id)copyWithZone:(NSZone *)zone {
    zhRemovableEditSectionModel *model = [[zhRemovableEditSectionModel allocWithZone:zone] init];
    model.title = self.title;
    model.attributedTitle = self.attributedTitle;
    model.itemModels = self.itemModels;
    return model;
}

@end
