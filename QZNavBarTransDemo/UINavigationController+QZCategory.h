//
//  UINavigationController+QZCategory.h
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (QZCategory)<UINavigationBarDelegate, UINavigationControllerDelegate>
- (void)setNeedsNavigationBackground:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
