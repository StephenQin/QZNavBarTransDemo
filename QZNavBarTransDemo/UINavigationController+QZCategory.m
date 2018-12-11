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
    NSLog(@"fromRed = %f toRed = %f fromGreen = %f toGreen = %f fromBlue = %f toBlue = %f fromAlpha = %f toAlpha = %f",fromRed,toRed,fromGreen,toGreen,fromBlue,toBlue,fromAlpha,toAlpha);
    NSLog(@"nowRed = %f nowGreen = %f nowBlue = %f nowAlha = %f",nowRed,nowGreen,nowBlue,nowAlpha);
    NSLog(@"percent = %f",percent);
    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
}
// 设置导航栏背景透明度
- (void)setNeedsNavigationBackground:(CGFloat)alpha {
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
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 交换的方法，监控滑动手势
- (void)et__updateInteractiveTransition:(CGFloat)percentComplete {
    [self et__updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            UIViewController *fromViewController = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController   = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = [fromViewController.navBarBgAlpha floatValue];
            CGFloat toAlpha   = [toViewController.navBarBgAlpha floatValue];
            CGFloat nowAlpha  = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            NSLog(@"from:%f, to:%f, now:%f",fromAlpha, toAlpha, nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
            // 设置Tint color
            UIColor *fromColor = fromViewController.navBarTintColor;
            UIColor *toColor   = toViewController.navBarTintColor;
            self.navigationBar.tintColor = [self setAverageColorFromColor:fromColor toColor:toColor andPercent:percentComplete];
        }
    }
}

#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
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
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            NSLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarTintColor;
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            NSLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
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
    [self setNeedsNavigationBackground:[self.topViewController.navBarBgAlpha floatValue]];
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
