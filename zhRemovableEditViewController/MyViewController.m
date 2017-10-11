//
//  MyViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/29.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyViewController.h"
#import "MyModel.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)zh_commonConfiguration {
    [super zh_commonConfiguration];
    self.showReservezone = YES;
    self.useSpringAnimation = YES;
    self.fixedCount = 4;
    self.maxCount = 8;
}

- (void)zh_loadData {
    self.dataArray = [MyModel testModel].mutableCopy;
}

@end
