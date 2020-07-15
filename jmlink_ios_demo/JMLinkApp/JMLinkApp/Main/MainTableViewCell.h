//
//  MainTableViewCell.h
//  JMLinkApp
//
//  Created by xudong.rao on 2020/6/2.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
- (void)setTopIcon:(NSString *_Nullable)topIcon icon:(NSString *_Nullable)icon title:(NSString *_Nullable)title;
- (void)showLogoCell;
@end

NS_ASSUME_NONNULL_END
