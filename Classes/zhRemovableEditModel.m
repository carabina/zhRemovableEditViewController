//
//  zhRemovableEditModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditModel.h"

@interface zhRemovableEditItemModel ()

@property (nonatomic, assign) NSInteger zh_markId;
@property (nonatomic, assign) BOOL zh_usingReservezone;
@property (nonatomic, assign) BOOL zh_isInvisible;

@end

@implementation zhRemovableEditItemModel

+ (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    return [[self alloc] modelWithUniqueId:uniqueId];
}

- (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    model.zh_markId = uniqueId;
    model.zh_usingReservezone = NO;
    model.zh_isInvisible = NO;
    return model;
}

- (NSInteger)uniqueId {
    return self.zh_markId;
}

- (id)copyWithZone:(NSZone *)zone {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    model.zh_markId = self.uniqueId;
    model.title = self.title;
    model.iconName = self.iconName;
    model.iconUrl = self.iconUrl;
    model.badgeState = self.badgeState;
    model.zh_usingReservezone = self.zh_usingReservezone;
    model.zh_isInvisible = self.zh_isInvisible;
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    NSDictionary *renameDict = [self zh_renameKeys];
    [renameDict enumerateKeysAndObjectsUsingBlock:^(NSString *realKey, NSString *renameKey, BOOL * _Nonnull stop) {
        if ([renameKey isEqualToString:key]) [self setValue:value forKey:realKey];
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSDictionary *renameDict = [self zh_renameKeys];
    if ([key isEqualToString:@"uniqueId"] || [key isEqualToString:renameDict[@"uniqueId"]]) {
        [self setValue:value forKey:@"zh_markId"];
    } else {
        if (![renameDict.allValues containsObject:key]) {
            NSLog(@"** %@ UndefinedKey: %@ ** ", self, key);
        }
    }
}

- (NSDictionary<NSString *,NSString *> *)zh_renameKeys {
    return @{};
}

@end

@implementation zhRemovableEditGroupModel

- (id)copyWithZone:(NSZone *)zone {
    zhRemovableEditGroupModel *model = [[zhRemovableEditGroupModel allocWithZone:zone] init];
    model.groupTitle = self.groupTitle;
    model.attributedTitle = self.attributedTitle;
    model.groupItems = self.groupItems;
    return model;
}

+ (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data {
    return [[self alloc] mapWithData:data];
}

- (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data {
    if (![data isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *dataArray = @[].mutableCopy;
    for (NSDictionary *groupData in data) {
        NSArray<NSDictionary *> *dataItems = [groupData objectForKey:@"groupItems"];
        if (!dataItems) {
            NSDictionary *renameDict = [self zh_renameKeys];
            dataItems = [groupData objectForKey:renameDict[@"groupItems"]];
        }
        NSParameterAssert([dataItems isKindOfClass:[NSArray class]]);
        NSMutableArray<zhRemovableEditItemModel *> *models = @[].mutableCopy;
        for (NSDictionary *dict in dataItems) {
            zhRemovableEditItemModel *model = [[[self zh_groupItemsSubclass] alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [models addObject:model];
        }
        zhRemovableEditGroupModel *groupModel = [[self.class alloc] init];
        [groupModel setValuesForKeysWithDictionary:groupData];
        groupModel.groupItems = models;
        [dataArray addObject:groupModel];
    }
    return dataArray.mutableCopy;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    NSDictionary *renameDict = [self zh_renameKeys];
    if ([self isMemberOfClass:[zhRemovableEditGroupModel class]]) {
        if (![key isEqualToString:@"groupItems"] &&
            ![key isEqualToString:renameDict[@"groupItems"]]) [super setValue:value forKey:key];
        return;
    }
    [super setValue:value forKey:key];
    [renameDict enumerateKeysAndObjectsUsingBlock:^(NSString *realKey, NSString *renameKey, BOOL * _Nonnull stop) {
        if ([renameKey isEqualToString:key]) [self setValue:value forKey:realKey];
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (![[self zh_renameKeys].allValues containsObject:key]) {
        NSLog(@"** %@ UndefinedKey: %@ ** ", self, key);
    }
}

- (Class)zh_groupItemsSubclass {
    return [zhRemovableEditItemModel class];
}

- (NSDictionary *)zh_renameKeys {
    return @{};
}

@end
