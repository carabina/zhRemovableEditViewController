//
//  zhRemovableEditModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhRemovableEditModel.h"
#import <objc/runtime.h>

@interface zhRemovableEditItemModel ()

@property (nonatomic, assign) BOOL zh_usingReservezone; // 辅助是否显示预留区使用
@property (nonatomic, assign) BOOL zh_isInvisible;  // 辅助做添加动画使用

@end

@implementation zhRemovableEditItemModel

static void *zh_markUniqueIdKey = &zh_markUniqueIdKey;

- (void)zh_setUniqueId:(NSInteger)uniqueId {
    objc_setAssociatedObject(self, zh_markUniqueIdKey, @(uniqueId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)zh_getUniqueId {
    return [objc_getAssociatedObject(self, zh_markUniqueIdKey) integerValue];
}

- (NSInteger)uniqueId {
    return [self zh_getUniqueId];
}

+ (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    return [[self alloc] modelWithUniqueId:uniqueId];
}

- (instancetype)modelWithUniqueId:(NSInteger)uniqueId {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    [model zh_setUniqueId:uniqueId];
    model.zh_usingReservezone = NO;
    model.zh_isInvisible = NO;
    return model;
}

- (id)copyWithZone:(NSZone *)zone {
    zhRemovableEditItemModel *model = [[zhRemovableEditItemModel alloc] init];
    [model zh_setUniqueId:self.uniqueId];
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
        [self zh_setUniqueId:[value integerValue]];
    } else {
        if (![renameDict.allValues containsObject:key]) {
            NSLog(@"** %@ UndefinedKey: %@ ** ", self, key);
        }
    }
}

- (id)valueForKey:(NSString *)key { // 用于模型转成数组或字典时过滤掉私有属性
    if ([key isEqualToString:@"zh_isInvisible"] || [key isEqualToString:@"zh_usingReservezone"]) return nil;
    if ([key isEqualToString:@"zh_beInvisible"]) return [super valueForKey:@"zh_isInvisible"];
    if ([key isEqualToString:@"zh_makeReservezone"]) return [super valueForKey:@"zh_usingReservezone"];
    return [super valueForKey:key];
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
        if (!dataItems) dataItems = [groupData objectForKey:[self zh_renameKeys][@"groupItems"]];
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

+ (NSArray<NSDictionary *> *)unmapWithArray:(NSArray<zhRemovableEditGroupModel *> *)dataArray {
    NSMutableArray *array = @[].mutableCopy;
    for (id object in dataArray) {
        id result = [self recursiveKeyValueWithObj:object];
        [array addObject:result];
    }
    return array;
}

+ (NSDictionary *)recursiveKeyValueWithObj:(id)object {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    Class class = [object class];
    unsigned int count;
    while (class!=[NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            id value = [object valueForKey:propertyName];
            if (!value) continue;
            NSMutableArray<id> *array = @[].mutableCopy;
            if ([value isKindOfClass:[NSArray class]]) {
                for (id obj in (NSArray *)value) {
                    id result = [self recursiveKeyValueWithObj:obj];
                    [array addObject:result];
                }
                dictionary[propertyName] = array;
            } else {
                dictionary[propertyName] = value;
            }
        }
        if (properties) {
            free(properties);
        }
        class = class_getSuperclass(class); // 得到父类的信息
    }
    return dictionary;
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

- (void)unmap {
    
}

@end
