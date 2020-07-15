//
//  GroupSceneViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "GroupSceneViewController.h"
#import "Common.h"
@interface GroupSceneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIView *headView;
@property(strong, nonatomic) UIButton *inviteBtn;

@property (strong, nonatomic) NSMutableArray *userList;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation GroupSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拼团邀请";
    [self setRefreshButton:YES];
    
    
    
    self.tableView = [[UITableView alloc] init];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
      self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
          make.top.equalTo(self.view.mas_top);
          make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
          make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
          make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
          make.edges.equalTo(self.view);
        }
    }];

    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = RGB(245, 245, 245);
    //self.headView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 553.0);
    self.tableView.tableHeaderView = self.headView;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.tableView.tableHeaderView);
        make.width.equalTo(self.tableView.mas_width);
        //make.height.mas_equalTo(553.0);
        
    }];

    CGFloat origin_width = 355.0;
    CGFloat origin_height = 454.0;
    
    CGFloat scale = origin_height / origin_width;
    CGFloat image_width = SCREEN_WIDTH - 2*10;
    CGFloat image_height = image_width * scale;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"scene_team_image"];
    imageView.layer.cornerRadius = 10.0;
    imageView.layer.masksToBounds = YES;
    [self.headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.headView).offset(10);
        make.right.equalTo(self.headView).offset(-10);
        make.height.mas_equalTo(image_height);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *color1 = RGB(101.0,140.0,255.0);
    UIColor *color2 = RGB(58.0,81.0,255.0);
    CAGradientLayer *gradientLayer = [Common gradientStartColor:color1 endColor:color2 view:btn1 size:CGSizeMake(312, 45)];
    gradientLayer.cornerRadius = 45.0/2.0;
    gradientLayer.masksToBounds = YES;
    
    
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"创建拼团/邀请其他人加入" forState:UIControlStateNormal];
    btn1.showsTouchWhenHighlighted = YES;
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [btn1 addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.inviteBtn = btn1;
    [self.headView addSubview:self.inviteBtn];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(312.0);
        make.height.mas_equalTo(45.0);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(17.0);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-10);
    }];
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
    
    self.userModel.type = NoCodeInviteModelType;
    self.userModel.scene = GroupScene;
    self.userModel.title = [NSString stringWithFormat:@"%@ 邀请你加入拼团",self.userModel.username];
    self.userModel.page = 1;
    
    NSString *groupId = [[NSUserDefaults standardUserDefaults] objectForKey:@"jmlink_group_id"];
    if (groupId) {
        self.userModel.groupId = [groupId longLongValue];
    }
    NSArray *array = @[
                        @{@"username":self.userModel.username,
                          @"uid":@(self.userModel.uid),
                          @"icon":self.userModel.icon
                        }
                     ];
    self.userList = [NSMutableArray arrayWithArray:array];
    [self refreshAction];

    [self startTimer];
    
    //
    if (self.paramModel) {
        if (self.userModel.groupId && self.userModel.groupId != 0) {
            if (self.userModel.groupId != self.paramModel.groupId) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经加入一个拼团，是否重新加入此拼团？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"加入", nil];
                alert.tag = 101;
                [alert show];
                return;
            }else{
                //已经在团里了
                return;
            }
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ 邀请你加入拼团",[Common urlDecodeString:self.paramModel.username]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"加入", nil];
        alert.tag = 102;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //加入
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:@(self.paramModel.groupId) forKey:@"group_id"];
        [param setObject:@(self.userModel.uid) forKey:@"uid"];
        [param setObject:self.userModel.username forKey:@"username"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWork enterGroup:param handler:^(NSInteger code, NSString * _Nonnull desc) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (desc) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:desc delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            if (code == 0) {
                self.userModel.groupId = self.paramModel.groupId;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",self.userModel.groupId] forKey:@"jmlink_group_id"];
            }
            [self refreshAction];
        }];
    }
}
- (void)inviteAction {
    if (self.userModel.groupId && self.userModel.groupId != 0) {
        [self clickShareEvent];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetWork getGroupId:^(NSString * _Nullable groupId) {
            if (groupId && groupId.length > 0) {
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:groupId forKey:@"group_id"];
                [param setObject:@(self.userModel.uid) forKey:@"uid"];
                [param setObject:self.userModel.username forKey:@"username"];
                
                [NetWork enterGroup:param handler:^(NSInteger code, NSString * _Nonnull desc) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (code == 0) {
                        self.userModel.groupId = [groupId longLongValue];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lld",self.userModel.groupId] forKey:@"jmlink_group_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self refreshAction];
                        [self clickShareEvent];
                        
                    }else{
                        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建拼团失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [Alert show];
                    }
                }];
            }else{
               [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }
}
- (void)refreshAction {
    if (self.userModel.groupId && self.userModel.groupId != 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *groupId = [NSString stringWithFormat:@"%lld",self.userModel.groupId];
        [NetWork getGroupMembers:groupId handler:^(NSArray * _Nullable userArray, NSInteger status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (status == 0) {
                if (userArray) {
                    self.userList = [NSMutableArray arrayWithArray:userArray];
                }
            }else if (status == 1){//拼团id不存在
                [self.userList removeAllObjects];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jmlink_group_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{}
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = self.userList[indexPath.row];
    NSString *uidStr = dic[@"uid"];
    NSString *username = dic[@"username"];
    NSString *icon = [NSString stringWithFormat:@"user_icon_%d",(int)([uidStr longLongValue]%5 + 1)];
    if ([uidStr longLongValue] == self.userModel.uid) {
        icon = self.userModel.icon;
    }
    
    cell.imageView.image = [UIImage imageNamed:icon];
    cell.textLabel.text = username;
    cell.textLabel.textColor = RGB(34,35,40);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
