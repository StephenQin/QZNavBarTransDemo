//
//  ViewController.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+QZCategory.h"
#import "SecondVc.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)leftItemAction:(UIBarButtonItem *)letfItem {
    NSLog(@"左边");
}
- (void)rightItemAction:(UIBarButtonItem *)rightItem {
    NSLog(@"右边");
    [self pushBtnAction:nil];
}
- (void)pushBtnAction:(UIButton *)sender {
    SecondVc *vc2 = [SecondVc new];
    vc2.page = 0;
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navTitleColor = [UIColor blackColor];
}
- (void)setupNav {
    self.title = @"导航栏透明度过渡";
    self.navBarBgAlpha = 1.0;
    self.navBarTintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"编辑"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"编辑"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
     UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.leftBarButtonItem  = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
