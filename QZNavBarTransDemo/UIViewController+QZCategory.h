//
//  UIViewController+QZCategory.h
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (QZCategory)
@property (copy, nonatomic) NSString *navBarBgAlpha;
@property (nonatomic, strong) UIColor *navBarTintColor;
@end

NS_ASSUME_NONNULL_END
