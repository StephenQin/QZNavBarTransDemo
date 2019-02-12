//
//  UINavigationController+QZCategory.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "UINavigationController+QZCategory.h"
#import <objc/runtime.h>

#define IOS(n) [[[UIDevice currentDevice]systemVersion] floatValue] >= n
#ifdef DEBUG
#define QZLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define QZLog(FORMAT, ...) nil
#endif
// 记录目标Vc
static UIViewController *targetVc;
@implementation UINavigationController (QZCategory)
// 设置导航栏的tintcolor
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
            if (targetVc.showNavShadowLine) {
                shadowView.alpha = alpha;
                shadowView.hidden = alpha == 0;
            } else {
                shadowView.hidden = YES;
            }
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
+ (void)load {
    // 交换方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class selfClass = [self class];
        NSArray *arr = @[@"_updateInteractiveTransition:",@"popToViewController:animated:",@"popToRootViewControllerAnimated:"];
        for (NSString *str in arr) {
            NSString *new_str = [[@"qz_" stringByAppendingString:str] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method A = class_getInstanceMethod(selfClass, NSSelectorFromString(str));
            Method B = class_getInstanceMethod(selfClass, NSSelectorFromString(new_str));
            method_exchangeImplementations(A, B);
        }
    });
}
//+ (void)initialize {
//    if (self == [UINavigationController self]) {
//        // 交换方法
//        NSArray *arr = @[@"_updateInteractiveTransition:",@"popToViewController:animated:",@"popToRootViewControllerAnimated:"];
//        for (NSString *str in arr) {
//            NSString *new_str = [[@"qz_" stringByAppendingString:str] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
//            Method A = class_getInstanceMethod(self, NSSelectorFromString(str));
//            Method B = class_getInstanceMethod(self, NSSelectorFromString(new_str));
//            method_exchangeImplementations(A, B);
//        }
//    }
//}

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
    targetVc = viewController;
    [self setNeedsNavigationBackgroundAlpha:viewController.navBarBgAlpha];
    self.navigationBar.tintColor = viewController.navBarTintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:viewController.navTitleColor};
    return [self qz_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)qz_popToRootViewControllerAnimated:(BOOL)animated {
    targetVc = self.viewControllers[0];
    [self setNeedsNavigationBackgroundAlpha:targetVc.navBarBgAlpha];
    self.navigationBar.tintColor = self.viewControllers[0].navBarTintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:self.viewControllers[0].navTitleColor};
    return [self qz_popToRootViewControllerAnimated:animated];
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        targetVc = targetVc;
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha;
            QZLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackgroundAlpha:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarTintColor;
        }];
    } else {// 自动完成了返回手势
        targetVc = self.topViewController;
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navBarBgAlpha;
            QZLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackgroundAlpha:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextToViewControllerKey].navBarTintColor;
        }];
    }
}


#pragma mark - UINavigationBar Delegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item { // 此处右滑返回也走
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
    targetVc = self.topViewController;
    [self setNeedsNavigationBackgroundAlpha:self.topViewController.navBarBgAlpha];
    self.navigationBar.tintColor = self.topViewController.navBarTintColor;
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    targetVc = self.topViewController;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    UIViewController *topVc = self.topViewController;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:topVc.navTitleColor};
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end

@interface UINavigationBar (QZCategory)
/** 导航栏分割线显隐*/
@property (assign, nonatomic) BOOL showNavShadowLine;
@end
@implementation UINavigationBar (QZCategory)
static char *QZCategoryShowNavShadowLineKey = "QZCategoryShowNavShadowLineKey";
- (BOOL)showNavShadowLine {
    if (objc_getAssociatedObject(self, QZCategoryShowNavShadowLineKey) == nil) {
        return YES;
    }
    return [objc_getAssociatedObject(self, QZCategoryShowNavShadowLineKey) boolValue];
}
- (void)setShowNavShadowLine:(BOOL)showNavShadowLine {
    if (self.subviews.count == 0) {return;}
    UIView *barBackground = self.subviews[0];
    /// 黑线
    UIImageView *shadowView = [barBackground valueForKey:@"_shadowView"];
    if (IOS(11)) {
        shadowView.hidden = !showNavShadowLine;
    } else {
        shadowView.alpha = showNavShadowLine;
    }
    objc_setAssociatedObject(self, QZCategoryShowNavShadowLineKey, @(showNavShadowLine), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
@implementation UIViewController (QZCategory)
//定义常量 必须是C语言字符串
static char *QZCategoryAlphaKey      = "QZCategoryAlphaKey";
static char *QZCategoryTintColorKey  = "QZCategoryTintColorKey";
static char *QZCategoryTitleColorKey = "QZCategoryTitleColorKey";
- (void)setNavBarBgAlpha:(CGFloat)navBarBgAlpha {
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, QZCategoryAlphaKey, @(navBarBgAlpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackgroundAlpha:navBarBgAlpha];
}
- (CGFloat)navBarBgAlpha {
    return [objc_getAssociatedObject(self, QZCategoryAlphaKey) floatValue];
}
- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    self.navigationController.navigationBar.tintColor = navBarTintColor;
    objc_setAssociatedObject(self, QZCategoryTintColorKey,navBarTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIColor *)navBarTintColor {
    return objc_getAssociatedObject(self, QZCategoryTintColorKey) ? : [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
}
- (void)setNavTitleColor:(UIColor *)navTitleColor {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:navTitleColor};
    objc_setAssociatedObject(self, QZCategoryTitleColorKey, navTitleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIColor *)navTitleColor {
    return objc_getAssociatedObject(self, QZCategoryTitleColorKey) ? : [UIColor blackColor];
}
- (BOOL)showNavShadowLine {
    if (objc_getAssociatedObject(self, QZCategoryShowNavShadowLineKey) == nil) {
        return YES;
    }
    return [objc_getAssociatedObject(self, QZCategoryShowNavShadowLineKey) boolValue];
}
- (void)setShowNavShadowLine:(BOOL)showNavShadowLine {
    self.navigationController.navigationBar.showNavShadowLine = showNavShadowLine;
    objc_setAssociatedObject(self, QZCategoryShowNavShadowLineKey, @(showNavShadowLine), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
