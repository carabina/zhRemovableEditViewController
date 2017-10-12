//
//  MyItemModel.h
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/12.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "zhRemovableEditModel.h"
#import <MJExtension/MJExtension.h>

@interface MyItemModel : zhRemovableEditItemModel


@end

@interface MyGroupModel : zhRemovableEditGroupModel

@property (nonatomic, strong) NSString *myTitle;

@end
