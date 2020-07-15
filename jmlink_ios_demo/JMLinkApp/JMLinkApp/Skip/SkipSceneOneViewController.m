//
//  SkipSceneOneViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "SkipSceneOneViewController.h"
@interface SkipSceneOneViewController ()
//@property (nonatomic, strong) ShareView * shareView;
@end

@implementation SkipSceneOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱看视频";
    [self setShareButton:YES];
    
    self.view.backgroundColor = RGB(0,20,89);
    
    UIImageView *loginImageview = [[UIImageView alloc] init];
    loginImageview.contentMode = UIViewContentModeScaleAspectFill;
    loginImageview.image = [UIImage imageNamed:@"scene_aikan_image"];
    [self.view addSubview:loginImageview];
    
    CGFloat f = 604.0/375.0;
    CGFloat height = SCREEN_WIDTH*f;
    CGFloat space = SCREEN_HEIGHT - (isIphoneX?84:64) - height;
    [loginImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(height);
        make.left.right.equalTo(self.view);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
    UIColor *color1 = RGB(255,233,212);
    UIColor *color2 = RGB(255,218,165);
    CAGradientLayer *gradientLayer = [Common gradientStartColor:color1 endColor:color2 view:btn1 size:CGSizeMake(312, 45)];
    gradientLayer.cornerRadius = 45.0/2.0;
    gradientLayer.masksToBounds = YES;
    
    
    [btn1 setTitleColor:RGB(0,22,78) forState:UIControlStateNormal];
    [btn1 setTitle:@"分享好友" forState:UIControlStateNormal];
    btn1.showsTouchWhenHighlighted = YES;
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [btn1 addTarget:self action:@selector(clickShareEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(312.0);
        make.height.mas_equalTo(45.0);
        make.centerX.equalTo(self.view.mas_centerX);
        if (space>=0) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-space- 70);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).offset(-55);
        }
        
    }];
    
    
    self.userModel.type = SkipModelType;
    self.userModel.scene = VideoScene;
    self.userModel.title = self.title;
    self.userModel.page = 4;
    
//    if (self.paramModel) {
//        NSString *str = [self.paramModel toJson:NO];
//        NSArray *arrar = [str componentsSeparatedByString:@"&"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"一链直达参数" message:[Common urlDecodeString:[Common unicode:arrar.description]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}
@end
