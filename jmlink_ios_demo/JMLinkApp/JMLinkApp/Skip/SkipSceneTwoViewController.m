//
//  SkipSceneTwoViewController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/27.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "SkipSceneTwoViewController.h"

@interface SkipSceneTwoViewController ()
//@property (nonatomic, strong) ShareView * shareView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SkipSceneTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三国演义";
    [self setShareButton:YES];
    
    self.userModel.type = SkipModelType;
    self.userModel.scene = ReadScene;
    self.userModel.title = self.title;
    self.userModel.page = 2;
    
//    if (self.paramModel) {
//        NSString *str = [self.paramModel toJson];
//        NSArray *arrar = [str componentsSeparatedByString:@"&"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"一链直达参数" message:[Common urlDecodeString:[Common unicode:arrar.description]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}

@end
