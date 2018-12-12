//
//  UINavigationController+QZCategory.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "UINavigationController+QZCategory.h"
#import <objc/runtime.h>
#import "UIViewController+QZCategory.h"
@implementation UINavigationController (QZCategory)
// 设置导航栏的颜色
- (UIColor *)setAverageColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor andPercent:(CGFloat)percent {
    CGFloat fromRed   = 0.0;
    CGFloat fromGreen = 0.0;
    CGFloat fromBlue  = 0.0;
    CGFloat fromAlpha = 0.0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    CGFloat toRed   = 0.0;
    CGFloat toGreen = 0.0;
    CGFloat toBlue  = 0.0;
    CGFloat toAlpha = 0.0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    CGFloat nowRed   = fromRed   + (toRed - fromRed) * percent;
    CGFloat nowGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat nowBlue  = fromBlue  + (toBlue - fromBlue) * percent;
    CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
}
// 设置导航栏背景透明度
- (void)setNeedsNavigationBackgroundAlpha:(CGFloat)alpha {
    if ([self.navigationBar subviews].count == 0) {return;}
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];
    if (barBackgroundView) {
        UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
        if (shadowView) {
            shadowView.alpha = alpha;
            shadowView.hidden = alpha == 0;
        }
        if (self.navigationBar.isTranslucent) {
            if (@available(iOS 10.0, *)) {
                UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
                if (backgroundEffectView && [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] == nil) {
                    backgroundEffectView.alpha = alpha;
                    return;
                };
            } else {
                UIView *adaptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
                UIView *backdropEffectView = [adaptiveBackdrop valueForKey:@"_backdropEffectView"];
                if (adaptiveBackdrop && backdropEffectView) {
                    backdropEffectView.alpha = alpha;
                    return;
                }
            }
        }
        barBackgroundView.alpha = alpha;
    }
}

+ (void)initialize {
    if (self == [UINavigationController self]) {
        // 交换方法
        NSArray *arr = @[@"_updateInteractiveTransition:",@"popToViewController:animated:",@"popToRootViewControllerAnimated:"];
        for (NSString *str in arr) {
            NSString *new_str = [[@"qz_" stringByAppendingString:str] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method A = class_getInstanceMethod(self, NSSelectorFromString(str));
            Method B = class_getInstanceMethod(self, NSSelectorFromString(new_str));
            method_exchangeImplementations(A, B);
        }
    }
}

// 交换的方法，监控滑动手势
- (void)qz_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor) {
            UIViewController *fromViewController = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController   = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = fromViewController.navBarBgAlpha;
            CGFloat toAlpha   = toViewController.navBarBgAlpha;
            CGFloat nowAlpha  = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            [self setNeedsNavigationBackgroundAlpha:nowAlpha];
            // 设置Tint color
            UIColor *fromColor = fromViewController.navBarTintColor;
            UIColor *toColor   = toViewController.navBarTintColor;
            self.navigationBar.tintColor = [self setAverageColorFromColor:fromColor toColor:toColor andPercent:percentComplete];
        }
    }
    [self qz_updateInteractiveTransition:(percentComplete)];
}
- (NSArray<UIViewController *> *)qz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setNeedsNavigationBackgroundAlpha:viewController.navBarBgAlpha];
    self.navigationBar.tintColor = viewController.navBarTintColor;
    return [self qz_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)qz_popToRootViewControllerAnimated:(BOOL)animated {
    [self setNeedsNavigationBackgroundAlpha:self.viewControllers[0].navBarBgAlpha];
    self.navigationBar.tintColor = self.viewControllers[0].navBarTintColor;
    return [self qz_popToRootViewControllerAnimated:animated];
}
#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            if (@available(iOS 10.0, *)) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                    [self dealInteractionChanges:context];
                }];
            } else {
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    [self dealInteractionChanges:context];
                }];
            }
        }
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha;
            NSLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackgroundAlpha:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarTintColor;
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navBarBgAlpha;
            NSLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackgroundAlpha:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextToViewControllerKey].navBarTintColor;
        }];
    }
}


#pragma mark - UINavigationBar Delegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *topVc = self.topViewController;
    id<UIViewControllerTransitionCoordinator> coor = topVc.transitionCoordinator;
    if (self.topViewController && coor && coor.initiallyInteractive) {
        if (@available(iOS 10.0, *)) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                [self dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
               [self dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    NSInteger itemCount = self.navigationBar.items.count;
    NSInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(nonnull UINavigationItem *)item {
    [self setNeedsNavigationBackgroundAlpha:self.topViewController.navBarBgAlpha];
    self.navigationBar.tintColor = self.topViewController.navBarTintColor;
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end
