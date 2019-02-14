//
//  QZFullBackNavigationController.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2019/2/14.
//  Copyright © 2019 Stephen Hu. All rights reserved.
//

#import "QZFullBackNavigationController.h"

@interface QZFullBackNavigationController ()<UIGestureRecognizerDelegate>
@property(nullable, nonatomic, readwrite) UIGestureRecognizer *fullInteractivePopGestureRecognizer;
@end

@implementation QZFullBackNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = NO;
    // 将原滑动返回手势的view、target、action取出来赋值给新的全屏手势
    UIView *view = self.interactivePopGestureRecognizer.view;
    id target  = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    // 创建新的返回手势并添加到原返回手势的view上
    self.fullInteractivePopGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    self.fullInteractivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.fullInteractivePopGestureRecognizer.delegate = self;
    [view addGestureRecognizer:self.fullInteractivePopGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 左滑时可能与UITableView左滑删除手势产生冲突
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {return NO;}
    // 跟视图控制器不响应手势
    return ([self.viewControllers count] == 1) ? NO : YES;
}

//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
