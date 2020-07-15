//
//  GameSceneViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "GameSceneViewController.h"
#import "Common.h"

@interface GameSceneViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *leftUserNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *rightUserNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;


@property (strong, nonatomic) NSMutableArray *userList;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation GameSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"游戏邀请";
    [self setRefreshButton:YES];
    
    
    self.bgView.layer.shadowOffset =  CGSizeMake(0, 2);           //阴影的偏移量
    self.bgView.layer.shadowOpacity = 1;                        //阴影的不透明度
    self.bgView.layer.shadowColor = RGB(230.0, 237.0, 255.0).CGColor;//阴影的颜色
    self.bgView.layer.borderColor = RGB(230.0, 237.0, 255.0).CGColor;
    self.bgView.layer.borderWidth = 1.0;
    
    self.myIcon.layer.cornerRadius = 21.0;
    self.myIcon.layer.masksToBounds = YES;
    self.myIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.myNameLabel.text = @"?";
    
    self.leftUserIcon.layer.cornerRadius = 21.0;
    self.leftUserIcon.layer.masksToBounds = YES;
    self.leftUserIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.leftUserNameLabel.text = @"?";
    
    self.rightUserIcon.layer.cornerRadius = 21.0;
    self.rightUserIcon.layer.masksToBounds = YES;
    self.rightUserIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.rightUserNameLabel.text = @"?";
        
    UIColor *color1 = RGB(101.0,140.0,255.0);
    UIColor *color2 = RGB(58.0,81.0,255.0);
    CAGradientLayer *gradientLayer = [Common gradientStartColor:color1 endColor:color2 view:self.inviteBtn size:CGSizeMake(312, 45)];
    gradientLayer.cornerRadius = 45.0/2.0;
    gradientLayer.masksToBounds = YES;
    
    
    [self.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.inviteBtn setTitle:@"邀请其他人加入游戏" forState:UIControlStateNormal];
    self.inviteBtn.showsTouchWhenHighlighted = YES;
    self.inviteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.inviteBtn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];

    self.createBtn.layer.cornerRadius = 45.0/2.0;
    self.createBtn.layer.masksToBounds = YES;
    self.createBtn.layer.borderWidth = 1.0;
    self.createBtn.layer.borderColor = RGB(58,81,255).CGColor;
    [self.createBtn setTitleColor:RGB(58,81,255) forState:UIControlStateNormal];
    [self.createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];

    
    self.userModel.type = NoCodeInviteModelType;
    self.userModel.scene = GameScene;
    self.userModel.title = [NSString stringWithFormat:@"%@ 邀请你加入游戏",self.userModel.username];
    self.userModel.page = 6;
    
    NSString *roomid = [[NSUserDefaults standardUserDefaults] objectForKey:@"jmlink_room_id"];
    if (roomid) {
        self.userModel.roomId = [roomid longLongValue];
        self.myIcon.image = [UIImage imageNamed:self.userModel.icon];
        self.myNameLabel.text = self.userModel.username;
        [self refreshAction];
    }
    
    //
    if (self.paramModel) {
        if (self.userModel.roomId && self.userModel.roomId != 0) {
            if (self.userModel.roomId != self.paramModel.roomId) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经加入一个游戏房间，是否重新加入此游戏房间？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"加入", nil];

                alert.tag = 101;
                [alert show];
                return;
            }else{
                // 已经在房间里了
                return;
            }
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ 邀请你加入游戏",[Common urlDecodeString:self.paramModel.username]];;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"加入", nil];
        alert.tag = 102;
        [alert show];
    }
    [self startTimer];
}
- (void)defaultUsers{
    self.myIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.myNameLabel.text = @"?";
    
    self.leftUserIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.leftUserNameLabel.text = @"?";
    
    self.rightUserIcon.image = [UIImage imageNamed:@"user_icon_default"];
    self.rightUserNameLabel.text = @"?";
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //加入
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@(self.paramModel.roomId) forKey:@"room_id"];
        [param setObject:@(self.userModel.uid) forKey:@"uid"];
        [param setObject:self.userModel.username forKey:@"username"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWork enterRoom:param handler:^(NSInteger code, NSString * _Nonnull desc) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (desc) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            if (code == 0) {
                self.userModel.roomId = self.paramModel.roomId;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",self.userModel.roomId] forKey:@"jmlink_room_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self refreshAction];
        }];
    }
}
- (void)refreshAction {
    if (self.userModel.roomId && self.userModel.roomId != 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWork getRoomMembers:[NSString stringWithFormat:@"%lld",self.userModel.roomId] handler:^(NSArray * _Nullable userArray,NSInteger status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.roomIdLabel.text = [NSString stringWithFormat:@"房间号:%lld",self.userModel.roomId];
            if (status == 0) {
                if (userArray) {
                    [self defaultUsers];
                    self.userList = [NSMutableArray arrayWithArray:userArray];
                    for (int i = 0; i < self.userList.count; i++) {
                        NSDictionary *dic = self.userList[i];
                        NSString *uidStr = dic[@"uid"];
                        NSString *username = dic[@"username"];
                        NSString *icon = [NSString stringWithFormat:@"user_icon_%d",(int)([uidStr longLongValue]%5 + 1)];
                        
                        if ([uidStr longLongValue] == self.userModel.uid) {
                            username = @"我";
                        }
                        
                        if (i == 0) {
                            self.myNameLabel.text = username;
                            self.myIcon.image = [UIImage imageNamed:icon];
                        }else if (i == 1) {
                            self.leftUserNameLabel.text = username;
                            self.leftUserIcon.image = [UIImage imageNamed:icon];
                        }else {
                            self.rightUserNameLabel.text = username;
                            self.rightUserIcon.image = [UIImage imageNamed:icon];
                        }
                    }
                }
            }else if (status == 1){//不存在
                [self defaultUsers];
            }else {}
        }];
    }
}

- (void)inviteAction {
    if (self.userModel.roomId && self.userModel.roomId != 0) {
        [self clickShareEvent];
    }else{
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先创建游戏房间" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
    }
}

- (void)createAction {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWork getRoomId:^(NSString * _Nullable roomId) {
        
        NSLog(@"roomId:%@",roomId);
        if (roomId && roomId.length > 0) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:roomId forKey:@"room_id"];
            [param setObject:@(self.userModel.uid) forKey:@"uid"];
            [param setObject:self.userModel.username forKey:@"username"];
            [NetWork enterRoom:param handler:^(NSInteger code, NSString * _Nonnull desc) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (code == 0) {
                    self.userModel.roomId = [roomId longLongValue];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",self.userModel.roomId] forKey:@"jmlink_room_id"];
                    [self.userList removeAllObjects];
                    self.myIcon.image = [UIImage imageNamed:self.userModel.icon];
                    self.myNameLabel.text = @"我";
                    
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游戏房间创建成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [Alert show];
                    [self refreshAction];
                }else{
                    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游戏房间创建失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [Alert show];
                }
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"游戏房间创建失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Alert show];
        }
    }];
}
- (void)startTimer{//10 second 调用一次
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}
-(void)updateTimer {
    [self refreshAction];
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTimer];
}
@end
