//
//  SecondVc.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "SecondVc.h"
#import "UINavigationController+QZCategory.h"
#import "UIViewController+QZCategory.h"
#import "ThirdVc.h"
@interface SecondVc ()

@end

@implementation SecondVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"alpha = 0.0";
    self.view.backgroundColor = [UIColor colorWithRed:0x32/255.0f green:0xAB/255.0f blue:0x64/255.0f alpha:1.0f];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push2ThirdVc:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    btn.bounds = CGRectMake(0, 0, 80, 35);
    [self.view addSubview:btn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
    self.navBarTintColor = [UIColor whiteColor];
}
- (void)push2ThirdVc:(UIButton *)sender {
    ThirdVc *tVc = [ThirdVc new];
    [self.navigationController pushViewController:tVc animated:YES];
}

@end
