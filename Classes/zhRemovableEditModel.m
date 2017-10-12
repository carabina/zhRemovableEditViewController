//
//  zhRemovableEditModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditModel.h"
#import <objc/runtime.h>

@implementation NSDictionary (RESafeAccess)

- (NSArray *)arrayForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    return [value isKindOfClass:[NSArray class]] ? value : nil;
}

- (NSString *)stringForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSString class]]) return (NSString *)value;
    if ([value isKindOfClass:[NSNumber class]]) return [value stringValue];
    return nil;
}

- (NSInteger)integerValueForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    return ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) ? [value integerValue] : 0;
}

@end

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

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [self setValue:value forKey:@"zh_markId"];
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
    return [self mapWithData:data renameKeys:nil];
}

+ (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data
                                                  renameKeys:(NSDictionary<NSString *,NSString *> *)renameKeys {
    if (![data isKindOfClass:[NSArray class]]) return nil;
    
    NSString* (^getRealKey)(NSString *) = ^(NSString *key){
        if (!renameKeys) return key;
        NSString *realKey = [renameKeys objectForKey:key];
        return realKey ? realKey : key;
    };
    
    NSMutableArray *dataArray = @[].mutableCopy;
    for (NSDictionary *groupData in data) {
        NSString *groupTitle = [groupData stringForKey:getRealKey(@"groupTitle")];
        NSString *groupSubTitle = [groupData stringForKey:getRealKey(@"groupSubTitle")];
        NSArray<NSDictionary *> *dataItems = [groupData arrayForKey:getRealKey(@"groupItems")];
        NSMutableArray<zhRemovableEditItemModel *> *models = @[].mutableCopy;
        for (NSDictionary *dict in dataItems) {
            NSInteger uniqueId = [dict integerValueForKey:getRealKey(@"uniqueId")];
            NSString *title = [dict stringForKey:getRealKey(@"title")];
            NSString *iconUrl = [dict stringForKey:getRealKey(@"iconUrl")];
            NSString *iconName = [dict stringForKey:getRealKey(@"iconName")];
            NSInteger badgeState = [dict integerValueForKey:getRealKey(@"badgeState")];
            zhRemovableEditItemModel *model = [zhRemovableEditItemModel modelWithUniqueId:uniqueId];
            model.title = title;
            model.iconUrl = iconUrl;
            model.iconName = iconName;
            model.badgeState = badgeState;
            [models addObject:model];
        }
        zhRemovableEditGroupModel *groupModel = [[zhRemovableEditGroupModel alloc] init];
        groupModel.groupTitle = groupTitle;
        groupModel.groupSubTitle = groupSubTitle;
        groupModel.groupItems = models;
        [dataArray addObject:groupModel];
    }
    return dataArray.mutableCopy;
}

@end
