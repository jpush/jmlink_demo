//
//  MainViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/13.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "MainViewController.h"

#import "ParamViewController.h"
#import "ReplayViewController.h"
#import "SkipViewController.h"
#import "TemplateViewController.h"
#import "MainTableViewCell.h"

@interface MainViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIImageView *loginImageview;
@property(assign, nonatomic) BOOL isEnough ;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"魔链（JMLink）";
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    self.tableView = [[UITableView alloc] init];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
      self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.loginImageview = [[UIImageView alloc] init];
    self.loginImageview.image = [UIImage imageNamed:@"logo"];
//    self.loginImageview.backgroundColor = [UIColor redColor];
    
    
    CGFloat session_h1 = isIphoneX?(44 + 306):(20 + 306);
    CGFloat session_h2 = 6 + (15+60)*4;
    CGFloat tab_height = session_h1 + session_h2;
    self.isEnough = YES;
    if (SCREEN_HEIGHT < tab_height) {
        self.isEnough = NO;
        tab_height = SCREEN_HEIGHT;
    }else{
        [self.view addSubview:self.loginImageview];
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
        make.height.mas_equalTo(tab_height);
    }];

    if (self.isEnough) {
        [self.loginImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0,*)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view.mas_bottom);
            }
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(100.0);
        }];
    }
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    return self.isEnough?4:5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return isIphoneX?(44 + 306):(20 + 306);
    }else{
        if (indexPath.row == 0) {
            return 6+15+60;
        }else{
            return 15+60;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"MainTableViewCell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        //xib文件
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        [cell setTopIcon:@"main_bg" icon:nil title:nil];
    }else{
        switch (indexPath.row) {
            case 0: [cell setTopIcon:nil icon:@"skip_icon" title:@"一链直达"];
                break;
            case 1: [cell setTopIcon:nil icon:@"replay_icon" title:@"场景还原"];
                break;
            case 2: [cell setTopIcon:nil icon:@"nocode_icon" title:@"无码邀请"];
                break;
            case 3: [cell setTopIcon:nil icon:@"tip_icon" title:@"丰富模板页"];
                break;
            case 4:{
                [cell showLogoCell];
            }
                
            default:
                break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        return;
    }
    UIViewController *vc = nil;
    switch (indexPath.row) {
           case 0: {
               vc = [[SkipViewController alloc] init];
           }
               break;
           case 1: {
               vc = [[ReplayViewController alloc] init];
           }
               break;
           case 2: {
               vc = [[ParamViewController alloc] init];
           }
               break;
           case 3: {
               vc = [[TemplateViewController alloc] init];
           }
               break;
           default:
               break;
       }
       if (vc) {
           [self.navigationController pushViewController:vc animated:YES];
       }
}

@end
