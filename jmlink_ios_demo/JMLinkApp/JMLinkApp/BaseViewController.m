//
//  BaseViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/5/21.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    // 导航栏字体、大小
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFangSC-Regular" size:17],NSFontAttributeName,nil]];
    
    // 导航栏渐变色
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = isIphoneX ? (64 + 20) : 64;
    CGRect frame = CGRectMake(0, 0, width , height);
        
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];

    UIGraphicsBeginImageContext(imgview.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGContextScaleCTM(context, frame.size.width, frame.size.height);

    CGFloat colors[] = {
        101.0/255.0, 140.0/255.0, 255.0/255.0, 1.0,
        58.0/255.0, 81.0/255.0, 238.0/255.0, 1.0,
    };

    CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    //设置颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
    [self.navigationController.navigationBar setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext()  forBarMetrics:UIBarMetricsDefault];
    

    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 35, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.rightBtn.hidden = YES;
    
}
-(JMLinkParamModel *)userModel{
    JMLinkParamModel *p = [JMLinkManager sharedClient].currentUser;
    _userModel = p;
    return _userModel;
}

- (void)setShareButton:(BOOL)show {
    self.rightBtn.hidden = !show;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"share_btn_normal"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"share_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.rightBtn addTarget:self action:@selector(clickShareEvent) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setRefreshButton:(BOOL)show {
    self.rightBtn.hidden = !show;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"refresh_btn_normal"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"refresh_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.rightBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickShareEvent {
    [self.shareView showWithContentType:JSHARELink];
}
- (void)refreshAction {
}


- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [ShareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
        switch (type) {
          case JSHARELink:
                [Common shareLinkWithPlatform:platform model:self.userModel];
            break;
          default:
            break;
        }
      }];
        [self.view addSubview:self.shareView];
    }
    return _shareView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
