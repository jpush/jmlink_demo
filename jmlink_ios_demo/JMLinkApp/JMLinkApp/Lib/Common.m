//
//  Common.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/4/13.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "Common.h"
#import <CoreImage/CoreImage.h>
#import "Common.h"



@implementation Common
+ (NSString *)unicode:(NSString *)string {
    NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [[NSString alloc] initWithData:strData encoding:NSNonLossyASCIIStringEncoding];
    return str;
}
// 编码  urlencode
+ (NSString *)urlEncodedString:(NSString *)urlStr {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlStr,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%[]",//#
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

// 解码 urldecode
+ (NSString *)urlDecodeString:(NSString *)urlStr {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)urlStr, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

//生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size
{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:size];
    return img;
}
//二维码清晰
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
//    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (void)shareLinkWithPlatform:(JSHAREPlatform)platform model:(nonnull JMLinkParamModel *)model{
    
    NSString *url_pre = [NSString stringWithFormat:@"%@/page%ld",JMLink_URL_H5,(long)model.page];
    NSString *url = [url_pre stringByAppendingFormat:@"?%@",[model toJson]];
        
    if (platform == JSHAREPlatformCopy) {
        [[UIPasteboard generalPasteboard] setString:url];
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"复制成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    if (platform == JSHAREPlatformOpenSafari) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }

    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
    message.url = url;
    message.title = model.title;
    message.text = @"欢迎使用极光魔链JMLink";
    message.platform = platform;
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"AppIcon"]);
    message.image = imageData;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
//        [Common showAlertWithState:state error:error];
    }];
}

+ (void)showAlertWithState:(JSHAREState)state error:(NSError *)error{
    
    NSString *string = nil;
    if (error) {
        string = [NSString stringWithFormat:@"分享失败,error:%@", error.description];
    }else{
        switch (state) {
            case JSHAREStateSuccess:
                string = @"分享成功";
                break;
            case JSHAREStateFail:
                string = @"分享失败";
                break;
            case JSHAREStateCancel:
                string = @"分享取消";
                break;
            case JSHAREStateUnknown:
                string = @"Unknown";
                break;
            default:
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
    });
}
+ (NSString *)localizedStringTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}
+ (CAGradientLayer *)gradientStartColor:(UIColor *)color1 endColor:(UIColor *)color2 view:(UIView *)view size:(CGSize)size {
    
    /*
     colors 渐变的颜色
     locations 渐变颜色的分割点
     startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
     */
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    gradientLayer.locations = @[@0.5];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [view.layer addSublayer:gradientLayer];
    return gradientLayer;
}
+ (void)saveFirstInstall {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_install"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isFirstInstall {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"first_install"];
}
+ (void)saveUID:(NSString *)uid {
    if (uid) {
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"jmlink_uid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (NSString *)getUID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"jmlink_uid"];
}
+ (void)saveName:(NSString *)name {
    if (name) {
           [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"jmlink_name"];
           [[NSUserDefaults standardUserDefaults] synchronize];
       }
}
+ (NSString *)getName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"jmlink_name"];
}
+ (void)saveIcon:(NSString *)icon {
    if (icon) {
           [[NSUserDefaults standardUserDefaults] setObject:icon forKey:@"jmlink_icon"];
           [[NSUserDefaults standardUserDefaults] synchronize];
       }
}
+ (NSString *)getIcon {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"jmlink_icon"];
}

+ (NSMutableString*)randomCreatChinese:(NSInteger)count{
    NSMutableString*randomChineseString =@"".mutableCopy;
    for(NSInteger i = 0; i < count; i++){
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //随机生成汉字高位
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        //随机生成汉子低位
        NSInteger randomL =0xB0+arc4random()%(0xF7-0xB0+1);

        //组合生成随机汉字
        NSInteger number = (randomH<<8)+randomL;
        NSData*data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc]initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString;
}
+ (NSString *)randomChinese {
    NSArray *array = @[@"泣幽咽", @"山色远", @"封尘忘", @"醒复醉", @"听江声", @"柳眉梢", @"山木夕",
    @"温如言", @"青烟尽", @"忘太多", @"遮青衣", @"离城梦", @"梦千遍", @"夜微凉", @"小情绪", @"痴人心",
    @"十指浅", @"半心人", @"小情歌", @"花君子", @"陌小伊", @"糖果果", @"萌小呆", @"莎酷拉", @"数流年",
    @"旧巷情人", @"笔墨书香", @"沧笙踏歌", @"南鸢离梦", @"游于长野", @"木槿昔年", @"夏已微凉", @"岁月静好",
                       @"灯火阑珊", @"清烟无瘾", @"孤寂深海", @"离殇荡情", @"挽袖清风", @"淡若清风", @"飞颜尘雪"];
    
    NSInteger number = arc4random()%array.count;
    NSString *name = array[number];
    return name;
}

/*
 
 */
@end

@implementation JMLinkManager

+ (instancetype)sharedClient{
    static JMLinkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[JMLinkManager alloc] init];
        }
    });
    return manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *currentUid = [Common getUID];
        if (!currentUid) {
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
            double i = time;
            //NSTimeInterval返回的是double类型
            NSString * uniqueString = [NSString stringWithFormat:@"%.f",i];
            [Common saveUID:uniqueString];
            currentUid = uniqueString;
        }
        NSString *name = [Common getName];
        if (!name) {
            name = [Common randomChinese];
            [Common saveName:name];
        }
        
        NSString *icon = [Common getIcon];
        if (!icon) {
            icon = [NSString stringWithFormat:@"user_icon_%d",(int)([currentUid longLongValue]%5 + 1)];
            [Common saveIcon:icon];
        }
        
        self.currentUser = [[JMLinkParamModel alloc] init];
        self.currentUser.uid = [currentUid longLongValue];
        self.currentUser.username = name;
        self.currentUser.icon = icon;
        NSLog(@"currentUser:%@",self.currentUser.username);
    }
    return self;
}

@end

@implementation JMLinkParamModel
+ (instancetype)initWithParam:(NSDictionary *)param {
    if (!param || param.count <= 0) {
        return nil;
    }
    JMLinkParamModel *model = [[JMLinkParamModel alloc] init];
    if (!param[@"type"] && [param[@"type"] isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (!param[@"scene"] && [param[@"scene"] isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    model.type = (JMLAppModelType)[[param objectForKey:@"type"] integerValue];
    model.scene = (JMLAppSceneType)[[param objectForKey:@"scene"] integerValue];
    
    if (param[@"uid"] && [param[@"uid"] isKindOfClass:[NSString class]]) {
        NSString *st = [NSString stringWithFormat:@"%@",[param objectForKey:@"uid"]];
        model.uid =  [st longLongValue];
    }
    
    if (param[@"username"] && [param[@"username"] isKindOfClass:[NSString class]]) {
        model.username = [Common urlDecodeString:[param objectForKey:@"username"]];
    }
    
    if (param[@"room_id"] && [param[@"room_id"] isKindOfClass:[NSString class]]) {
        model.roomId = [[param objectForKey:@"room_id"] longLongValue];
    }
    
    if (param[@"group_id"] && [param[@"group_id"] isKindOfClass:[NSString class]]) {
        model.groupId = [[param objectForKey:@"group_id"] longLongValue];
    }
    
    return model;
}
- (NSString *)toJson{
    return [self toJson:YES];
}
- (NSString *)toJson:(BOOL)encode{
    NSString *str = @"";
    if (self.type) {
        str = [str stringByAppendingFormat:@"type=%ld",(long)self.type];
    }
    if (self.scene) {
        str = [str stringByAppendingFormat:@"&scene=%ld",(long)self.scene];
    }
    if (self.uid) {
        str = [str stringByAppendingFormat:@"&uid=%lld",self.uid];
    }
    if (self.username) {
        str = [str stringByAppendingFormat:@"&username=%@",encode?[Common urlEncodedString:self.username]:self.username];
    }
    if (self.roomId) {
        str = [str stringByAppendingFormat:@"&room_id=%lld",self.roomId];
    }
    if (self.groupId) {
        str = [str stringByAppendingFormat:@"&group_id=%lld",self.groupId];
    }
    return str;
}
//判断是否为iphone X

+ (BOOL)isiPhoneX {
    if (@available(iOS 11.0,*)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f) {
            return YES;
        }
        return YES;
    }
    return NO;
}

//安全区域高度
+ (float)safeBottomHeight {
    if (@available(iOS 11.0,*)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        return bottomSafeInset;
    }
    return 0.0f;
}

@end
