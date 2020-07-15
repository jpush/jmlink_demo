//
//  NetWork.h
//  JMLinkApp
//
//  Created by xudong.rao on 2020/6/15.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString const * _Nonnull JMLink_URL_H5 = @"https://demo.jmlk.co/#";
static NSString const * _Nonnull JMLink_URL_API = @"http://demo-jmlink.jpush.cn/jmlink-demo/v1/demo";

NS_ASSUME_NONNULL_BEGIN

@interface NetWork : NSObject
+ (void)reportGeneralizeUid:(NSString *)uid handler:(void(^)(NSInteger status))handler;
+ (void)getGeneralizeCountUid:(NSString *)uid handler:(void(^)(NSInteger count))handler;

///获取房间号接口
+ (void)getRoomId:(void(^)(NSString  * _Nullable roomId))handler;
///加入房间接口
+ (void)enterRoom:(NSDictionary *)param handler:(void(^)(NSInteger code,NSString *desc))handler;
///获取房间成员
+ (void)getRoomMembers:(NSString *)roomId handler:(void(^)(NSArray * _Nullable userArray,NSInteger status))handler;

+ (void)getGroupId:(void(^)(NSString *_Nullable groupId))handler;
+ (void)enterGroup:(NSDictionary *)param handler:(void(^)(NSInteger code,NSString *desc))handler ;
+ (void)getGroupMembers:(NSString *)groupId handler:(void(^)(NSArray * _Nullable userArray,NSInteger status))handler;
@end

NS_ASSUME_NONNULL_END
