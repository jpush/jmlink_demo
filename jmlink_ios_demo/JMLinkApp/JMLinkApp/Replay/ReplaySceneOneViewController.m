//
//  ReplaySceneOneViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "ReplaySceneOneViewController.h"

@interface ReplaySceneOneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ReplaySceneOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻资讯";
    [self setShareButton:YES];
    
    JML_CURRENT_USER.type = ReplayModelType;
    JML_CURRENT_USER.scene = NewsReadScene;
    
    JML_CURRENT_USER.title = self.title;
    self.userModel.page = 3;
    
    self.titleLabel.numberOfLines = 0;
    
//    if (self.paramModel) {
//        NSString *str = [self.paramModel toJson];
//        NSArray *arrar = [str componentsSeparatedByString:@"&"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"场景还原参数" message:[Common urlDecodeString:[Common unicode:arrar.description]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}


@end
