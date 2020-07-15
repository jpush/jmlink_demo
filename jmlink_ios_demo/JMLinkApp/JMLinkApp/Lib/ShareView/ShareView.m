//
//  ShareView.m
//  JShareDemo
//
//  Created by ys on 11/01/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import "ShareView.h"

@interface ShareView()

@property (nonatomic, assign) JSHAREMediaType type;

@property (nonatomic, strong) NSMutableDictionary * platformData;
@property (nonatomic, strong) NSMutableArray * currentContentSupportPlatform;

@property (nonatomic, strong) UIView * shareView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * cancelBtn;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat space;

@end

#define TopSpace 29
#define MidSpace 36
#define BottomSpace 34

#define ImageSize 58
#define ImageLabelSpace 13
#define ItemFontSize 11
#define CancelItemHeight 61
#define CancelFontSize 13

#define LineColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
#define FontColor [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]


@implementation ShareView {
    ShareBlock _block;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.space = (self.screenWidth-4*ImageSize)/5;
        self.shareView = [[UIView alloc] init];
        self.currentContentSupportPlatform = [[NSMutableArray alloc] init];
        
        self.platformData = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

+ (ShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block {
    ShareView * shareView = [[ShareView alloc] init];
    [shareView setShareCallBack:block];
    [shareView setShareView];
    [shareView setFacade];
    [shareView setCancelView];
    return shareView;
}

- (void)setFacade {
    self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
}

#define RemainTag 9999

- (void)setShareView {
    //white cover
    self.shareView.backgroundColor = [UIColor whiteColor];
    //gary line
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = LineColor;
    self.lineView.tag = RemainTag;
    [self.shareView addSubview:self.lineView];
    [self addSubview:self.shareView];
}

- (void)setShareItem {
    //clear history item
    for (UIView * view in self.shareView.subviews) {
        if (view.tag != 9999) {
            [view removeFromSuperview];
        }
    }
    //layout item
    for (int i=0; i<self.currentContentSupportPlatform.count; i++) {
        NSNumber * platformkey = self.currentContentSupportPlatform[i];
        NSInteger row = i/4;
        NSInteger column = i%4;
        UIButton * shareItem = self.platformData[platformkey][@"item"];
        shareItem.frame = CGRectMake((column+1)*self.space+column*ImageSize, TopSpace+row*(ImageSize+MidSpace+ItemFontSize+ImageLabelSpace), ImageSize, ImageSize);
        shareItem.tag = platformkey.integerValue;
        [shareItem addTarget:self action:@selector(shareTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [shareItem setImage:[UIImage imageNamed:self.platformData[platformkey][@"image"]] forState:UIControlStateNormal];
      
        UILabel * shareLabel = [[UILabel alloc] init];
        shareLabel.frame = CGRectMake(shareItem.frame.origin.x, CGRectGetMaxY(shareItem.frame)+ImageLabelSpace, CGRectGetWidth(shareItem.frame), ItemFontSize);
        shareLabel.textColor = FontColor;
        shareLabel.font = [UIFont systemFontOfSize:ItemFontSize];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = self.platformData[platformkey][@"title"];
      
        [self.shareView addSubview:shareItem];
        [self.shareView addSubview:shareLabel];
    }
    NSInteger totalRow = (self.currentContentSupportPlatform.count-1)/4+1;
    CGFloat shareViewHeight = TopSpace+totalRow*(ImageSize+ItemFontSize+ImageLabelSpace)+(totalRow-1)*MidSpace+BottomSpace+CancelItemHeight + 50;
    self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.screenWidth, shareViewHeight);
    self.cancelBtn.frame = CGRectMake(0, self.shareView.frame.size.height-CancelItemHeight, self.screenWidth, CancelItemHeight);
    self.lineView.frame = CGRectMake(self.space, self.shareView.frame.size.height-62, self.screenWidth-self.space*2, 1);
    [super setHidden:YES];
}

- (void)setCancelView {
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.tag = RemainTag;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:CancelFontSize];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:self.cancelBtn];
}

- (void)setShareCallBack:(ShareBlock)block {
    if (block) {
        _block = nil;
        _block = [block copy];
    }
}

- (void)shareTypeSelect:(UIButton *)sender {
    if (_block) {
      _block(sender.tag, self.type);
    }
    [self hiddenView];
}

- (void)showWithContentType:(JSHAREMediaType)type {
  [self setPlatformDataWithLogin:NO];
  self.type = type;
  [self.currentContentSupportPlatform removeAllObjects];
    switch (type) {
        case JSHARELink:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformOpenSafari),
                                                                      @(JSHAREPlatformCopy)/*,
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformSinaWeibo),
                                                                      @(JSHAREPlatformFacebook),
                                                                      @(JSHAREPlatformFacebookMessenger),
                                                                      @(JSHAREPlatformTwitter)*/]];
            break;
        default:
            break;
    }
  [self setShareItem];
  self.hidden = NO;
}

- (void)showWithSupportedLoginPlatform{
    [self setPlatformDataWithLogin:YES];
    [self.currentContentSupportPlatform removeAllObjects];
    [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),@(JSHAREPlatformQQ),@(JSHAREPlatformSinaWeibo),@(JSHAREPlatformFacebook),@(JSHAREPlatformTwitter), @(JSHAREPlatformJChatPro)]];
    [self setShareItem];
    self.hidden = NO;
}

- (void)setPlatformDataWithLogin:(BOOL)isLogin {
    NSArray * typeArr = @[@(JSHAREPlatformSinaWeibo),
                          @(JSHAREPlatformWechatSession),
                          @(JSHAREPlatformWechatTimeLine),
                          @(JSHAREPlatformWechatFavourite),
                          @(JSHAREPlatformQQ),
                          @(JSHAREPlatformQzone),
                          @(JSHAREPlatformFacebook),
                          @(JSHAREPlatformFacebookMessenger),
                          @(JSHAREPlatformTwitter),
                          @(JSHAREPlatformJChatPro),
                          @(JSHAREPlatformOpenSafari),
                          @(JSHAREPlatformCopy)];
    NSArray * titleArr = nil;
    if(isLogin){
        titleArr = @[@"新浪微博",@"微信好友",@"朋友圈",@"微信收藏",@"QQ",@"QQ空间",@"Facebook",@"Messenger",@"twitter",@"JChatPro",@"浏览器打开",@"复制"];
    }else {
        titleArr = @[@"新浪微博",@"微信好友",@"朋友圈",@"微信收藏",@"QQ",@"QQ空间",@"Facebook",@"Messenger",@"twitter",@"JChatPro",@"浏览器打开",@"复制"];
    }
    NSArray * imageArr = @[@"weibo",@"share_wechat",@"share_wechat_moment",@"wechat_fav",@"share_qq",@"share_qqzone",@"facebook",@"messenger",@"twitter",@"jchatpro",@"share_ie",@"share_copy"];
    for (int i=0; i<typeArr.count; i++) {
        [self.platformData setObject:@{@"title":titleArr[i], @"image":imageArr[i], @"item":[UIButton buttonWithType:UIButtonTypeCustom]} forKey:typeArr[i]];
    }
}
- (void)setHidden:(BOOL)hidden {
    if (!hidden) {
        [super setHidden:hidden];
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.screenHeight-CGRectGetHeight(self.shareView.frame), CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];;
        }];
    }else{
      [UIView animateWithDuration:0.3 animations:^{
          self.shareView.frame = CGRectMake(0, self.screenHeight, CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
      }];
      [UIView animateWithDuration:0.5 animations:^{
          self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.0];;
      } completion:^(BOOL finished) {
          [super setHidden:hidden];
      }];
    }
}

- (void)hiddenView {
    self.type = 0;
    self.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenView];
}

@end
