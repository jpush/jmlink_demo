//
//  TemplateViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/6/12.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()<UIScrollViewDelegate>

@property(strong, nonatomic) UIScrollView *topScrollView;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) NSMutableArray *data;
@property(assign, nonatomic) NSInteger index;
@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"丰富模板页";
    self.view.backgroundColor = RGB(245,245,245);
    
    NSArray *array = @[
    @{@"btnTitle":@"模板一",@"image":@"template_1"},
    @{@"btnTitle":@"模板二",@"image":@"template_2"},
    @{@"btnTitle":@"模板三",@"image":@"template_3"},
    @{@"btnTitle":@"模板四",@"image":@"template_4"},
    @{@"btnTitle":@"模板五",@"image":@"template_5"},
    @{@"btnTitle":@"模板六",@"image":@"template_6"}
    ];
    self.data = [NSMutableArray arrayWithArray:array];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.topScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topScrollView];
    CGFloat width = self.data.count * (14+86);
    if (width < SCREEN_WIDTH) {
        width = SCREEN_WIDTH;
    }
    self.topScrollView.contentSize = CGSizeMake(width,50);
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"支持定义品牌引导页，结合原生APP UI设计风格，整体统一，提升品牌形象";
    tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    tipLabel.textColor = RGB(130,131,139);
    tipLabel.numberOfLines = 0;
    tipLabel.frame = CGRectMake(25, CGRectGetMaxY(self.topScrollView.frame)+15, SCREEN_WIDTH-2*25, 60);
    [self.view addSubview:tipLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.topScrollView.frame))];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.data.count,SCREEN_HEIGHT -50);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = RGB(245,245,245);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    for (int i = 0; i < self.data.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:RGB(245,245,245) forState:UIControlStateNormal];
        //[btn setTitleColor:RGB(58,81,255) forState:UIControlStateSelected];
        [btn setTitle:self.data[i][@"btnTitle"] forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        btn.layer.borderColor = RGB(58,81,255).CGColor;
        btn.layer.borderWidth = 1.0;
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = YES;
        btn.frame = CGRectMake(14 + (86+12)*i, 11, 86, 28);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:btn];
        
        CGFloat width = 235.0;
        CGFloat height = 476.0;
        CGFloat origin_x = CGRectGetWidth(self.scrollView.frame)*i + (CGRectGetWidth(self.scrollView.frame)/2 - width/2);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:self.data[i][@"image"]];
        imageView.frame = CGRectMake( origin_x, 15, width, height);
        [self.scrollView addSubview:imageView];
    }
    [self didSelectIndex:1];
}

- (void)didSelect:(UIButton *)btn {
    [self didSelectIndex:btn.tag];
}

- (void)didSelectIndex:(NSInteger)index {
    for (id temp in self.topScrollView.subviews) {
        if ([temp isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)temp;
            if (subBtn.tag == index) {
                subBtn.layer.borderColor = RGB(58,81,255).CGColor;
                subBtn.backgroundColor = [UIColor whiteColor];
                [subBtn setTitleColor:RGB(58,81,255) forState:UIControlStateNormal];
            }else{
                subBtn.layer.borderColor = RGB(245,245,245).CGColor;
                subBtn.backgroundColor = RGB(245,245,245);
                [subBtn setTitleColor:RGB(127,127,127) forState:UIControlStateNormal];
            }
            
        }
    }
    if (index != self.index) {
        CGRect rect = self.scrollView.frame;
        rect.origin.x = self.scrollView.frame.size.width * (index -1);
        [self.scrollView scrollRectToVisible:rect animated:YES];
        self.index = index;
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"==:%f",scrollView.contentOffset.x);
    self.index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self didSelectIndex:self.index+1];
}
@end
