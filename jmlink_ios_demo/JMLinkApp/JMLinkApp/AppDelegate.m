//
//  AppDelegate.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/13.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"
// 引入 JSHARE 功能所需头文件
#import "JSHAREService.h"
#import "JMLinkService.h"

// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "Common.h"


#import "SkipSceneOneViewController.h"
#import "SkipSceneTwoViewController.h"
#import "ReplaySceneOneViewController.h"
#import "ReplaySceneTwoViewController.h"
#import "GeneralizeSceneViewController.h"
#import "GameSceneViewController.h"
#import "GroupSceneViewController.h"
#import "TemplateViewController.h"

/// 极光分配的 AppKey
#define JG_APP_KEY @"a0021ac628bbd4097f6f7da5"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self setupJMLink];
    [self setupJShare];
    
    
    // 更换返回按钮的图片
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_btn_norl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
    [UINavigationBar appearance].backIndicatorImage = backButtonImage;
    
    
    MainViewController *vc = [[MainViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

/// 初始换 JShare （极光分享）
- (void)setupJShare {
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = JG_APP_KEY;
    config.QQAppId = @"1110355905";
    config.QQAppKey = @"1V2Xxjte9nM3Fmc2";
    config.WeChatAppId = @"wxd03c9dd32db1528e";
    config.WeChatAppSecret = @"41589636bbd35f7529190d6dcc8df44b";
    // 这个地址可以填写魔链任意一个支持universal link 的域名地址(不需要加AppKey也可以@since jmlink sdk v1.2.0)，要保证微信平台和这里是一致的
    config.universalLink = @"https://srguys.jmlk.co/a0021ac628bbd4097f6f7da5/";
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:YES];
}

/// 初始换 JMLink （极光魔链）
- (void)setupJMLink {
    
    if (@available(iOS 14,*)) {
        /// 因为 iOS 14 开始APP与外部通过剪切板传递数据会有系统弹框
        /// 如果不介意有系统弹框可以去掉这个判断
        /// 通过剪切板来传递数据会很大程度增加成功率
        /// 注：SDK 不会读其他数据，只是从 H5 传递魔链的数据到 SDK
        /// [JMLinkService pasteBoardEnable:NO];
    }
    
    [JMLinkService setDebug:YES];
    JMLinkConfig *mlinkConfig = [[JMLinkConfig alloc] init];
    mlinkConfig.appKey = JG_APP_KEY;
    [JMLinkService setupWithConfig:mlinkConfig];
    
    
    /*
     注意：
        SDK 提供了两个 handler 和一个获取无码邀请回调，这里只注册一个 default handler，没有去注册其他回调接口；
        这样可以避免后续增加了短链又要去匹配 jmlink key 的问题，直接使用 default handler 就可以一劳永逸，不需要每次都新增key 来匹配；
        剩下的就是在 default handler 里面增加开发者自己的一些参数协议解析了.
        无码邀请参数也可以直接用普通参数来代替，从而也使用同一个 default handler 获取参数，不需要又单独使用 getMLinkParam 接口。
     
        所以，一链直达、场景还原、无码邀请都可以用一个default handler完成，这是一个比较简单通用的处理方式。
            只需在defaultHander 里完成自己参数的解析即可。
     */
    [JMLinkService registerMLinkDefaultHandler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 拿到参数，去解析自己项目的参数
            [self processParam:params];
        });
    }];
}

/// 解析魔链返回的参数
- (void)processParam:(NSDictionary *)param {
    NSLog(@"processParam:%@",param);
    if (!param || param.count <= 0) {
        return;
    }
    JMLinkParamModel *model = [JMLinkParamModel initWithParam:param];
    if (!model) {
        return;
    }
    
    //  因为本项目是全部都用nav 做的，直接取顶层vc，如果比较复杂的项目需要考虑present、Nav、tab等情况
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UINavigationController *topNav = (UINavigationController *)[window rootViewController];
    UIViewController *topVC = topNav.topViewController;
    
    switch (model.type) {
        case SkipModelType:{
            if (model.scene == VideoScene) {
                if (![topVC isKindOfClass:[SkipSceneOneViewController class]]) {
                    SkipSceneOneViewController *vc = [[SkipSceneOneViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else if (model.scene == ReadScene) {
                if (![topVC isKindOfClass:[SkipSceneTwoViewController class]]) {
                    SkipSceneTwoViewController *vc = [[SkipSceneTwoViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else{
            }
        }
            break;
        case ReplayModelType:{
            if (model.scene == NewsReadScene) {
                if (![topVC isKindOfClass:[ReplaySceneOneViewController class]]) {
                    ReplaySceneOneViewController *vc = [[ReplaySceneOneViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else if (model.scene == GoodsBrowseScene) {
                if (![topVC isKindOfClass:[ReplaySceneTwoViewController class]]) {
                    ReplaySceneTwoViewController *vc = [[ReplaySceneTwoViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else{
            }
        }
            break;
        case NoCodeInviteModelType:{
            if (model.scene == GeneralizeScene) {
                if ([Common isFirstInstall]) {
                    // 地推直接弹框提示
                    NSString *str = [NSString stringWithFormat:@"您通过扫描[%@]的二维码下载魔链APP",[Common urlDecodeString:model.username]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    
                    // APP层自己加第一次安装判断更保险，第一次安装才上报相关信息，避免过度依赖SDK
                    if (![topVC isKindOfClass:[GeneralizeSceneViewController class]]) {
                        GeneralizeSceneViewController *vc = [[GeneralizeSceneViewController alloc] init];
                        vc.paramModel = model;
                        [topNav pushViewController:vc animated:YES];
                    }
                }
            }else if (model.scene == GameScene) {
                if (![topVC isKindOfClass:[GameSceneViewController class]]) {
                    GameSceneViewController *vc = [[GameSceneViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else if (model.scene == GroupScene) {
                if (![topVC isKindOfClass:[GroupSceneViewController class]]) {
                    GroupSceneViewController *vc = [[GroupSceneViewController alloc] init];
                    vc.paramModel = model;
                    [topNav pushViewController:vc animated:YES];
                }
            }else{}
        }
            break;
        case TemplateModelType:{
            
        }
            break;
            
        default:
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [Common saveFirstInstall];
}

//iOS9以下，通过url scheme来唤起app
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //必写
    [JMLinkService routeMLink:url];
    [JSHAREService handleOpenUrl:url];
    return YES;
}

//iOS9+，通过url scheme来唤起app
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //必写
    [JMLinkService routeMLink:url];
    [JSHAREService handleOpenUrl:url];
    return YES;
}

//通过universal link来唤起app
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //必写
    [JSHAREService handleOpenUrl:userActivity.webpageURL];
    [JMLinkService continueUserActivity:userActivity];
    return YES;
}
@end
