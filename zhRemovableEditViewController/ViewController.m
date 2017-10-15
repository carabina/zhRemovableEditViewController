//
//  ViewController.m
//  zhRemovableEditViewController
//
//  Created by zhanghao on 2017/9/28.
//  Copyright © 2017年 金慧盈通. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = CGPointMake(self.view.bounds.size.width / 2,
                                self.view.bounds.size.height / 2);
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 7;
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick {
    MyViewController *vc = [MyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
