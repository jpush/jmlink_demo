//
//  Common.h
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/13.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSHAREService.h"
#import "ShareView.h"


/// 模块
typedef NS_ENUM(NSInteger,JMLAppModelType){
    /// 一链直达
    SkipModelType = 1,
    /// 场景还原
    ReplayModelType = 2,
    /// 无码邀请
    NoCodeInviteModelType = 3,
    /// 丰富模板页
    TemplateModelType = 4,
};

/// 场景
typedef NS_ENUM(NSInteger,JMLAppSceneType){
    /// 爱看视频 场景
    VideoScene = 1,
    /// 小说阅读 场景
    ReadScene = 2,
    /// 新闻资讯
    NewsReadScene = 3,
    /// 商品浏览
    GoodsBrowseScene = 4,
    /// 地推 场景
    GeneralizeScene = 5,
    /// 游戏邀请 场景
    GameScene = 6,
    /// 拼团 场景
    GroupScene = 7,
};

NS_ASSUME_NONNULL_BEGIN

@class JMLinkParamModel;
@interface Common : NSObject

+ (NSString *)unicode:(NSString *)string;
/// 编码  urlencode
+ (NSString *)urlEncodedString:(NSString *)urlStr ;
/// 解码 urldecode
+ (NSString *)urlDecodeString:(NSString *)urlStr;

+ (void)shareLinkWithPlatform:(JSHAREPlatform)platform model:(JMLinkParamModel*)model;
+ (void)showAlertWithState:(JSHAREState)state error:(NSError *)error;
+ (NSString *)localizedStringTime;
+ (UIViewController *)findCurrentViewController;
//判断是否为iphone X
+ (BOOL)isiPhoneX;
+ (CAGradientLayer *)gradientStartColor:(UIColor *)color1 endColor:(UIColor *)color2 view:(UIView *)view size:(CGSize)size ;
///生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;

+ (void)saveFirstInstall;
+ (BOOL)isFirstInstall;

+ (void)saveUID:(NSString *)uid ;
+ (NSString *)getUID;

+ (void)saveName:(NSString *)name ;
+ (NSString *)getName;

+ (void)saveIcon:(NSString *)icon;
+ (NSString *)getIcon;

+ (NSMutableString*)randomCreatChinese:(NSInteger)count;
+ (NSString *)randomChinese;
@end

@class JMLinkParamModel;
@interface JMLinkManager : NSObject
+ (instancetype)sharedClient;
@property(nonatomic, strong) JMLinkParamModel *currentUser;
@end

@interface JMLinkParamModel : NSObject

@property (nonatomic, assign) JMLAppModelType type;
@property (nonatomic, assign) JMLAppSceneType scene;
@property (nonatomic, assign) long long uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) long long roomId;
@property (nonatomic, assign) long long groupId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) NSInteger page;

+ (instancetype)initWithParam:(NSDictionary *)param ;
- (NSString *)toJson;
//不加编码的
- (NSString *)toJson:(BOOL)encode;
@end

NS_ASSUME_NONNULL_END
