//
//  SkipViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/13.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "SkipViewController.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import "SkipSceneOneViewController.h"
#import "SkipSceneTwoViewController.h"

@interface SkipViewController ()

@property (nonatomic, strong) ShareView * shareView;
@end

@implementation SkipViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一链直达";
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"skip_image"];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(128.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(30.0);
    }];
 
    UILabel *label = [[UILabel alloc] init];
    label.text = @"JMLink一链直达";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(13.0);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"分享内容集成短链服务，用户点击可唤醒已安装的应用并跳转目标页面";
    detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = RGB(130.0,131.0,139.0);
    detailLabel.numberOfLines = 0;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(11.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(294.0);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
    UIColor *color1 = RGB(101.0,140.0,255.0);
    UIColor *color2 = RGB(58.0,81.0,255.0);
    CAGradientLayer *gradientLayer = [Common gradientStartColor:color1 endColor:color2 view:btn1 size:CGSizeMake(312, 45)];
    gradientLayer.cornerRadius = 45.0/2.0;
    gradientLayer.masksToBounds = YES;
    
    
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"选择场景体验" forState:UIControlStateNormal];
    btn1.showsTouchWhenHighlighted = YES;
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [btn1 addTarget:self action:@selector(selectScene) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(312.0);
        make.height.mas_equalTo(45.0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(detailLabel.mas_bottom).offset(32.0);
    }];
    
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"先下载魔链APP \n 以便更直观的体验一链直达功能";
    tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    tipLabel.textColor = RGB(130.0,131.0,139.0);
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(42.0);
        make.width.mas_equalTo(276.0);
    }];
}

- (void)selectScene {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择场景" message:@"请先下载魔链APP以便更好体验一链直达" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* actionDefault1 = [UIAlertAction actionWithTitle:@"爱看视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"titleOne is pressed");
        SkipSceneOneViewController *vc = [[SkipSceneOneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction* actionDefault2 = [UIAlertAction actionWithTitle:@"小说阅读" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"titleTwo is pressed");
        SkipSceneTwoViewController *vc = [[SkipSceneTwoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"titleThree is pressed");
    }];
    [alertVC addAction:actionDefault1];
    [alertVC addAction:actionDefault2];
    [alertVC addAction:actionCancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
