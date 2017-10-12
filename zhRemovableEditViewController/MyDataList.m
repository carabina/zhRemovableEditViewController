//
//  test.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "MyDataList.h"

@implementation MyDataList

+ (NSMutableArray<zhRemovableEditGroupModel *> *)testModel {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"MyData" ofType:@"json"];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                                  options:NSJSONReadingAllowFragments
                                                    error:nil];
    
    NSArray *responseData = [jsonObject objectForKey:@"Group"];
    NSMutableArray<zhRemovableEditGroupModel *> *dataArray = [MyGroupModel  mapWithData:responseData];
    return dataArray;
}

@end
