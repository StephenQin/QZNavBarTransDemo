//
//  QZTabBarController.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/12.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "QZTabBarController.h"
#import "QZBaseNavigationController.h"
#import "QZFullBackNavigationController.h"
#import "ViewController.h"
#import "ThirdVc.h"
@interface QZTabBarController ()

@end

@implementation QZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // MARK: - 添加子控制器
    self.tabBar.tintColor = [UIColor purpleColor];
    [self setupChildVcs];
}
#pragma mark - 添加子控制器
- (void)setupChildVcs {
    
    // 消息
    UINavigationController *vc1 = [self navWithClassName:@"ViewController" title:@"首页" imageName:@"home_normal" andSelectedImageName:@"home_selected" isFullBack:NO];
    UINavigationController *vc2 = [self navWithClassName:@"ThirdVc" title:@"商城" imageName:@"goods_normal" andSelectedImageName:@"goods_selected" isFullBack:YES];
    // 设置标签vc的子控制器
    self.viewControllers = @[vc1,vc2];
    
}

#pragma mark - 负责创建vc的方法
- (UINavigationController *)navWithClassName:(NSString *)clsName  title:(NSString *)title imageName:(NSString *)imgName andSelectedImageName:(NSString *)selectedImageName isFullBack:(BOOL)fullBack{
    
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc] init];
    // 断言! 了解!方便差错的!
    // 如果第一个参数的条件满足,直接往下走!否则,崩溃 -> 报错,错误信息就是参数2的内容
    NSAssert([vc isKindOfClass:[UIViewController class]], @"%@控制器类名写错了", clsName);
    // 3.设置内容 下面的tabbarItem + 上面的navigationItem
    //    vc.tabBarItem.title = title;
    //    vc.navigationItem.title = title;
    // 可以同时设置tabbarItem和navigationItem的标题!
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imgName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (fullBack) {
        QZFullBackNavigationController *nav = [[QZFullBackNavigationController alloc] initWithRootViewController:vc];
        return nav;
    }
    UINavigationController *nav = [[QZBaseNavigationController alloc] initWithRootViewController:vc];
    return nav;
}




@end
