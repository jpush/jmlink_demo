//
//  ReplaySceneTwoViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "ReplaySceneTwoViewController.h"

@interface ReplaySceneTwoViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;//滚动视图
@property (nonatomic, strong) UIView *mas_heighContentView;//用来获取contentSize 高度的视图
@property (nonatomic, strong) UIView *contentView;//真正的scrollView 内部承载视图
@property (nonatomic, strong) UIImageView *imageView;//contentView的子视图

@end

@implementation ReplaySceneTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品浏览";
    [self setShareButton:YES];
    
    CGFloat origin_width = 375.0;
    CGFloat origin_height = 749.0;
    
    CGFloat scale = origin_height / origin_width;
    CGFloat image_width = SCREEN_WIDTH;
    CGFloat image_height = SCREEN_WIDTH * scale;
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"scene_goods_image"];
    [self.contentView addSubview:self.imageView];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
        
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        //必须设置宽度 mas_right 对scrollView 没用
        make.width.mas_equalTo(image_width);
        //必须设置高度,用来撑开contentSize
        make.height.mas_equalTo(image_height);
    }];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);;
    }];
    
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
//    imageView2.backgroundColor = [UIColor redColor];
    imageView2.image = [UIImage imageNamed:@"btn"];
    [self.view addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
          make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(45);
    }];
    
    
    self.userModel.type = ReplayModelType;
    self.userModel.scene = GoodsBrowseScene;
    
    self.userModel.title = self.title;
    self.userModel.page = 5;
    
    
//    if (self.paramModel) {
//        NSString *str = [self.paramModel toJson];
//        NSArray *arrar = [str componentsSeparatedByString:@"&"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"场景还原参数" message:[Common urlDecodeString:[Common unicode:arrar.description]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}


@end
