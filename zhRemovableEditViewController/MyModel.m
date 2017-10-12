
//
//  MyItemModel.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/12.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyModel.h"

@implementation MyItemModel

@end

@implementation MyGroupModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"groupItems" : [MyItemModel class]};
}

@end
