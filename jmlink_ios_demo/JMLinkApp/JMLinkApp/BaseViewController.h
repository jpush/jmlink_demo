//
//  BaseViewController.h
//  JMLinkApp
//
//  Created by xudong.rao on 2020/5/21.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property(nonatomic, strong) JMLinkParamModel *userModel;

- (void)setShareButton:(BOOL)show;
- (void)setRefreshButton:(BOOL)show;

- (void)clickShareEvent;

- (void)refreshAction;

@end

NS_ASSUME_NONNULL_END
