//
//  MyItemModel.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/12.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "zhRemovableEditModel.h"

@interface MyItemModel : zhRemovableEditItemModel

@end

@interface MyGroupModel : zhRemovableEditGroupModel

@property (nonatomic, strong) NSString *myTitle;

+ (NSMutableArray<zhRemovableEditGroupModel *> *)mapWithData:(NSArray<id> *)data;

@end
