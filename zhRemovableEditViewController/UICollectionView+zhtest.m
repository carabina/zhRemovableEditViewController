//
//  UICollectionView+zhtest.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/10/13.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "UICollectionView+zhtest.h"
#import <objc/runtime.h>

@implementation UICollectionView (zhtest)

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"zh_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)zh_reloadData {
    
    [self zh_reloadData];
}

@end
