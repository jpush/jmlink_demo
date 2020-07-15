//
//  BaseNavigationController.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/14.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

// 返回按钮的文字置空（在UINavigationController的子类或者分类categary）中添加该方法
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.backBarButtonItem = back;
    return YES;
}

@end
