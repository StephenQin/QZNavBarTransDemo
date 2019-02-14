//
//  QZFullBackNavigationController.h
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2019/2/14.
//  Copyright © 2019 Stephen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZFullBackNavigationController : UINavigationController

@property(nullable, nonatomic, readonly) UIGestureRecognizer *fullInteractivePopGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
