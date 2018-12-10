//
//  ThirdVc.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ThirdVc.h"
#import "UINavigationController+QZCategory.h"
#import "UIViewController+QZCategory.h"
@interface ThirdVc ()

@end

@implementation ThirdVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"alpha = 0.8";
    self.view.backgroundColor = [UIColor greenColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.8";
}
@end
