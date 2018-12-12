//
//  SecondVc.m
//  QZNavBarTransDemo
//
//  Created by Stephen Hu on 2018/12/10.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "SecondVc.h"
#import "UINavigationController+QZCategory.h"
#import "ThirdVc.h"

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
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat showNavBarOffsetY = 200 - self.topLayoutGuide.length;
    if (contentOffsetY > showNavBarOffsetY) {
        CGFloat navAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0;
        if (navAlpha > 1) {
            navAlpha = 1;
        }
        self.navBarBgAlpha = navAlpha;
        if (navAlpha > 0.8) {
            self.navBarTintColor = [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];
            self.statusBarShouldLight = NO;
        } else {
            self.navBarTintColor = [UIColor whiteColor];
            self.statusBarShouldLight = YES;
        }
    } else {
        self.navBarBgAlpha = 0.0;
        self.navBarTintColor = [UIColor whiteColor];
        self.statusBarShouldLight = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SecondVc *seVc = [[SecondVc alloc] init];
    [self.navigationController pushViewController:seVc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor purpleColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarBgAlpha = 0.0;
    self.navBarTintColor = [UIColor whiteColor];
    [self setupTableView];
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
