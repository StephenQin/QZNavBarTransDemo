//
//  QZBaseNavigationController.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/11.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "QZBaseNavigationController.h"

@implementation QZBaseNavigationController
//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
