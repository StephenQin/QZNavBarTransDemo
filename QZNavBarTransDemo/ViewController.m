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
    SecondVc *vc2 = [SecondVc new];
    [self.navigationController pushViewController:vc2 animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarBgAlpha = 1.0;
    self.navBarTintColor = [UIColor blueColor];
    [self setupNav];
    [self setupUI];
}
- (void)setupUI {
    
}
- (void)setupNav {
    self.title = @"导航栏透明度过渡";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
     UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.leftBarButtonItem  = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
