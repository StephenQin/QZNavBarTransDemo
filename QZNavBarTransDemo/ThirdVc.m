//
//  ThirdVc.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ThirdVc.h"
#import "UINavigationController+QZCategory.h"
#import "SecondVc.h"
//#import "UIViewController+QZCategory.h"
@interface ThirdVc ()

@end

@implementation ThirdVc

- (void)pushBtnAction:(UIButton *)sender {
    SecondVc *vc2 = [SecondVc new];
    vc2.page = 0;
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)setupUI {
    UIButton *pushBtn = [UIButton new];
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    pushBtn.backgroundColor = [UIColor purpleColor];
    [pushBtn addTarget:self action:@selector(pushBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    pushBtn.bounds = CGRectMake(0, 0, 100, 50);
    pushBtn.center = self.view.center;
    [self.view addSubview:pushBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarBgAlpha = 0.8;
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"编辑"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"编辑"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"全屏返回";
    self.view.backgroundColor = [UIColor greenColor];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navTitleColor = [UIColor blackColor];
}
@end
