//
//  MainTableViewCell.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/6/2.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView.layer.shadowOffset =  CGSizeMake(0, 5);           //阴影的偏移量
    self.bottomView.layer.shadowOpacity = 1;                        //阴影的不透明度
    self.bottomView.layer.shadowColor = RGB(230.0, 237.0, 255.0).CGColor;//阴影的颜色
    self.bottomView.layer.borderColor = RGB(230.0, 237.0, 255.0).CGColor;
    self.bottomView.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTopIcon:(NSString *)topIcon icon:(NSString *)icon title:(NSString *)title {
    self.logoImageView.hidden = YES;
    if (topIcon) {
        self.topImageView.image = [UIImage imageNamed:topIcon];
        self.topView.hidden = NO;
        self.bottomView.hidden = YES;
    }else{
        if (title) {
            self.titleLabel.text = title;
            self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            self.titleLabel.textColor = RGB(34,35,40);
        }
        if (icon) {
            self.iconImageView.image = [UIImage imageNamed:icon];
        }
        self.topView.hidden = YES;
        self.bottomView.hidden = NO;
    }
//    [self.contentView updateConstraintsIfNeeded];
//    [self.contentView updateConstraints];
    
}
- (void)showLogoCell{
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    self.logoImageView.hidden = NO;
}
@end
