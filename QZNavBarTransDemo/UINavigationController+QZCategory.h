//
//  UINavigationController+QZCategory.h
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//  参考https://www.jianshu.com/p/454b06590cf1 swift版本翻译的，后来发现有人写过https://github.com/90ck/CKNavSmoothDemo oc版本

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (QZCategory)<UINavigationBarDelegate, UINavigationControllerDelegate>
- (void)setNeedsNavigationBackgroundAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
