//
//  SecondVc.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
// https://www.cnblogs.com/wi100sh/p/5605115.html

#import "SecondVc.h"
#import "UINavigationController+QZCategory.h"
#import "ThirdVc.h"
#define screen_max_length (MAX(kScreenWidth, kScreenHeight))
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define is_iPhoneX (screen_max_length >= 812.0)
#define kNavigationHeight (is_iPhoneX ? 88.0f : 64.0f)
#define kRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kRandomColor  kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)
static NSString *cellId = @"cellId";
@interface SecondVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL statusBarShouldLight;
@end

@implementation SecondVc

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusBarShouldLight) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}
#pragma mark ————— UITableViewDelegate,UITableViewDataSource —————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.page <= 10) {return;}
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat showNavBarOffsetY = 200 - self.topLayoutGuide.length;
    if (contentOffsetY > showNavBarOffsetY) {
        CGFloat navAlpha = (contentOffsetY - showNavBarOffsetY) / 40.0;
        if (navAlpha > 1) {
            navAlpha = 1;
        }
        self.navBarBgAlpha = navAlpha;
        if (navAlpha > 0.8) {
            self.navBarTintColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
            self.navTitleColor   = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
            self.statusBarShouldLight = NO;
        } else {
            self.navBarTintColor = [UIColor whiteColor];
            self.navTitleColor   = [UIColor whiteColor];
            self.statusBarShouldLight = YES;
        }
    } else {
        self.navBarBgAlpha   = 0.0;
        self.navBarTintColor = [UIColor whiteColor];
        self.navTitleColor   = [UIColor whiteColor];
        self.statusBarShouldLight = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.row <= 10) {
        cell.textLabel.text = [NSString stringWithFormat:@"导航栏alpha为0.%zd，并带有随机色的导航背景",indexPath.row];
    } else if (indexPath.row == 11) {
        cell.textLabel.text = @"导航栏alpha为0,没有线，没有导航背景";
    } else {
        cell.textLabel.text = @"导航栏alpha为0,没有导航背景";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SecondVc *seVc = [[SecondVc alloc] init];
    seVc.page = indexPath.row;
    seVc.title = [NSString stringWithFormat:@"第%zd个控制器",indexPath.row];
    [self.navigationController pushViewController:seVc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor purpleColor];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    imgV.image = [UIImage imageNamed:@"timg.jpeg"];
    [headerView addSubview:imgV];
    NSInteger x1 = [UIScreen mainScreen].bounds.size.width / 2 - 120;
    NSInteger x2 = [UIScreen mainScreen].bounds.size.width / 2 + 20;
    UIButton *backBtn          = [[UIButton alloc] initWithFrame:CGRectMake(x1, 100, 100, 40)];
    UIButton *backToRootBtn    = [[UIButton alloc] initWithFrame:CGRectMake(x2, 100, 100, 40)];
    [backBtn setTitle:@"pop" forState:UIControlStateNormal];
    [backToRootBtn setTitle:@"pop2root" forState:UIControlStateNormal];
    [backBtn       setBackgroundColor:[UIColor redColor]];
    [backToRootBtn setBackgroundColor:[UIColor redColor]];
    backBtn.titleLabel.textColor       = [UIColor whiteColor];
    backToRootBtn.titleLabel.textColor = [UIColor whiteColor];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backToRootBtn addTarget:self action:@selector(backToRootBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    [headerView addSubview:backToRootBtn];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}
- (void)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backToRootBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarTintColor = [UIColor whiteColor]; // 此处改变的是tintColor 会百变标题和item颜色
    self.navTitleColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.000 green:0.800 blue:0.800 alpha:1.000]]; // 此处改变的是BarTintColor
    [self setupTableView];
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kNavigationHeight)];
    navBgView.backgroundColor = kRandomColor;
    switch (self.page) {
        case 0:
            self.navBarBgAlpha = 0.0;
            [self.view addSubview:navBgView];
            break;
        case 1:
            self.navBarBgAlpha = 0.1;
            [self.view addSubview:navBgView];
            break;
        case 2:
            self.navBarBgAlpha = 0.2;
            [self.view addSubview:navBgView];
            break;
        case 3:
            self.navBarBgAlpha = 0.3;
            [self.view addSubview:navBgView];
            break;
        case 4:
            self.navBarBgAlpha = 0.4;
            [self.view addSubview:navBgView];
            break;
        case 5:
            self.navBarBgAlpha = 0.5;
            [self.view addSubview:navBgView];
            break;
        case 6:
            self.navBarBgAlpha = 0.6;
            [self.view addSubview:navBgView];
            break;
        case 7:
            self.navBarBgAlpha = 0.7;
            [self.view addSubview:navBgView];
            break;
        case 8:
            self.navBarBgAlpha = 0.8;
            [self.view addSubview:navBgView];
            break;
        case 9:
            self.navBarBgAlpha = 0.9;
            [self.view addSubview:navBgView];
            break;
        case 10:
            self.navBarBgAlpha = 1.0;
            self.showNavShadowLine = NO;
            [self.view addSubview:navBgView];
            break;
        case 11:
            self.navBarBgAlpha = 0.0;
            self.showNavShadowLine = NO;
            break;
        default:
            self.navBarBgAlpha = 0.0;
            break;
    }
}
- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = [UIColor blueColor];
}
#pragma mark ————— lazyLoad —————
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
@end
