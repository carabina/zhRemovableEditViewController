
//
//  MyItemModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/12.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyModel.h"
#import <objc/runtime.h>

@implementation MyItemModel

- (NSDictionary<NSString *,NSString *> *)zh_renameKeys {
    return @{@"title" : @"myTitle"};
}

@end

@implementation MyGroupModel

- (Class)zh_groupItemsSubclass {
    return [MyItemModel class];
}


@end
