//
//  test.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

+ (NSArray<zhRemovableEditSectionModel *> *)testModel {
    
    NSArray<NSString *> *arr1 = @[@"饿了么", @"淘票票", @"淘宝", @"转账", @"蚂蚁森林"];
    NSArray *idArr1 = @[@(204), @(205), @(206), @(301), @(302), @(-1)];
    __block NSMutableArray *muarray = [NSMutableArray array];
    [arr1 enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger unId = [idArr1[idx] integerValue];
        zhRemovableEditItemModel *model = [zhRemovableEditItemModel modelWithUniqueId:unId];
        model.title = title;
        model.image = [UIImage imageNamed:title];
        model.badgeState = zhRemovableEditBadgeStateMinus;
        if (idx < 4) {
            model.badgeState = zhRemovableEditBadgeStateNone;
        } else {
            model.badgeState = zhRemovableEditBadgeStateMinus;
        }
        [muarray addObject:model];
    }];
    zhRemovableEditSectionModel *sModel = [zhRemovableEditSectionModel new];
    sModel.itemModels = muarray;
    
    NSString *prefix = @"我的应用";
    NSString *text = @"(按住拖动调整排序)";
    NSString *message = [NSString stringWithFormat:@"%@ %@", prefix, text];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:message];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[message rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[message rangeOfString:text]];
    sModel.attributedTitle = attriText;
    
    
    NSArray<NSString *> *tuiArr1 = @[@"滴滴出行", @"天猫", @"共享单车", @"芝麻信用"];
    NSArray *idTuiArr1 = @[@(202), @(209), @(210), @(303), @(333)];
    __block NSMutableArray *tuimuarray = [NSMutableArray array];
    [tuiArr1 enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger unId = [idTuiArr1[idx] integerValue];
        zhRemovableEditItemModel *model = [zhRemovableEditItemModel modelWithUniqueId:unId];
        model.title = title;
        model.image = [UIImage imageNamed:title];
        model.badgeState = zhRemovableEditBadgeStatePlus;
        [tuimuarray addObject:model];
    }];
    zhRemovableEditSectionModel *tuisModel2 = [zhRemovableEditSectionModel new];
    tuisModel2.itemModels = tuimuarray;
    tuisModel2.title = @"推荐使用";
    
    
    NSArray<NSString *> *arr2 = @[@"到位", @"滴滴出行", @"运动", @"饿了么", @"淘票票", @"淘宝", @"服务", @"教育", @"天猫", @"共享单车", @"体育服务"];
    __block NSMutableArray *muarray2 = [NSMutableArray array];
    [arr2 enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger unId = 201 + idx;
        zhRemovableEditItemModel *model = [zhRemovableEditItemModel modelWithUniqueId:unId];
        model.title = title;
        model.image = [UIImage imageNamed:title];
        model.badgeState = zhRemovableEditBadgeStatePlus;
        if (unId > 203 && unId < 207) {
            model.badgeState = zhRemovableEditBadgeStateGray;
        }
        [muarray2 addObject:model];
    }];
    zhRemovableEditSectionModel *sModel2 = [zhRemovableEditSectionModel new];
    sModel2.itemModels = muarray2;
    sModel2.title = @"便民生活";
    
    
    NSArray<NSString *> *arr3 = @[@"转账", @"蚂蚁森林", @"芝麻信用", @"奖励金", @"AA收款"];
    __block NSMutableArray *muarray3 = [NSMutableArray array];
    [arr3 enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger unId = 301 + idx;
        zhRemovableEditItemModel *model = [zhRemovableEditItemModel modelWithUniqueId:unId];
        model.title = title;
        model.image = [UIImage imageNamed:title];
        model.badgeState = zhRemovableEditBadgeStatePlus;
        if (unId > 300 && unId < 303) {
            model.badgeState = zhRemovableEditBadgeStateGray;
        }
        [muarray3 addObject:model];
    }];
    zhRemovableEditSectionModel *sModel3 = [zhRemovableEditSectionModel new];
    sModel3.itemModels = muarray3;
    sModel3.title = @"财富管理";
    
    NSMutableArray *allDataArray = [NSMutableArray array];
    [allDataArray addObject:sModel];
    [allDataArray addObject:tuisModel2];
    [allDataArray addObject:sModel2];
    [allDataArray addObject:sModel3];
    return allDataArray;
}

@end
