//
//  ViewController.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+QZCategory.h"
#import "UIViewController+QZCategory.h"
#import "SecondVc.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)push2NextVc:(UIButton *)sender {
    SecondVc *vc2 = [SecondVc new];
    self.navigationController.delegate = self.navigationController;
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏透明度过渡";
}


@end
