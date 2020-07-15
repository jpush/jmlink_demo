//
//  GeneralizeSceneViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "GeneralizeSceneViewController.h"

@interface GeneralizeSceneViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;


@property (strong, nonatomic) NSString *number;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation GeneralizeSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地推";
    self.view.backgroundColor = RGB(245,245,245);
    [self setRefreshButton:YES];
    self.number = @"0";
    
    _bgView.layer.cornerRadius = 10.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _userIcon.layer.cornerRadius = 33.0;
    _userIcon.layer.masksToBounds = YES;
    _userIcon.image = [UIImage imageNamed:self.userModel.icon];
    [_bgView bringSubviewToFront:_userIcon];
    
    _nicknameLabel.text = self.userModel.username;
    _userIdLabel.text = [NSString stringWithFormat:@"UID:%lld",self.userModel.uid];
    
    _numLabel.layer.cornerRadius = 24.0;
    _numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.shadowOffset =  CGSizeMake(0, 3);           //阴影的偏移量
    self.numLabel.layer.shadowOpacity = 1;                        //阴影的不透明度
    self.numLabel.layer.shadowColor = RGB(230.0, 237.0, 255.0).CGColor;//阴影的颜色
    self.numLabel.layer.borderColor = RGB(230.0, 237.0, 255.0).CGColor;
    self.numLabel.layer.borderWidth = 1.0;
    
    
        
    self.userModel.type = NoCodeInviteModelType;
    self.userModel.scene = GeneralizeScene;
    self.userModel.title = [NSString stringWithFormat:@"%@ 邀请你下载【魔链APP】",self.userModel.username];
    self.userModel.page = 0;
    
    NSString *url = [NSString stringWithFormat:@"https://arguys.jmlk.co/AAlq?%@",[self.userModel toJson]];
    UIImage *img = [Common generateQRCodeWithString:url Size:_codeImageView.frame.size.width];
    _codeImageView.image = img;
    
    if (self.paramModel) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWork reportGeneralizeUid:[NSString stringWithFormat:@"%lld",self.paramModel.uid] handler:^(NSInteger status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    [self reloadNumberLabel];
    [self refreshAction];
    [self startTimer];
}
- (void)reloadNumberLabel {
    NSString *titleStr = [NSString stringWithFormat:@"累计推广人数 %@人",self.number];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSRange range1 = [[str string] rangeOfString:@"累计推广人数 "];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(130,131,139) range:range1];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:14] range:range1];
    NSRange range2 = [[str string] rangeOfString:[NSString stringWithFormat:@"%@人",self.number]];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(58,81,255) range:range2];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:22] range:range2];
    self.numLabel.attributedText = str;
}
- (void)refreshAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWork getGeneralizeCountUid:[NSString stringWithFormat:@"%lld",self.userModel.uid] handler:^(NSInteger count) {
        NSLog(@"getGeneralizeCountUid:%ld",(long)count);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.number = [NSString stringWithFormat:@"%ld",(long)count];
        [self reloadNumberLabel];
    }];
}

- (void)startTimer{//10 second 调用一次
    NSLog(@"startTimer");
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 这里先添加到当前runloop再赋值给timer
    self.timer = timer;
}
-(void)updateTimer {
    NSLog(@"updateTimer");
    if (self.userModel.uid > 0) {
        [NetWork getGeneralizeCountUid:[NSString stringWithFormat:@"%lld",self.userModel.uid] handler:^(NSInteger count) {
            NSLog(@"getGeneralizeCountUid:%ld",(long)count);
            self.number = [NSString stringWithFormat:@"%ld",(long)count];
            [self reloadNumberLabel];
        }];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}
- (void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
