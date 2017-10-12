
//
//  MyItemModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/12.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyItemModel.h"

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


@implementation MyItemModel

@end

@implementation MyGroupModel

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
        MyGroupModel *groupModel = [[MyGroupModel alloc] init];
        groupModel.groupTitle = groupTitle;
        groupModel.groupSubTitle = groupSubTitle;
        groupModel.groupItems = models;
        groupModel.myTitle = @"测试~~~";
        [dataArray addObject:groupModel];
    }
    return dataArray.mutableCopy;
}


@end
