//
//  NetWork.m
//  JMLinkApp
//
//  Created by xudong.rao on 2020/6/15.
//  Copyright © 2020 jiguang. All rights reserved.
//

#import "NetWork.h"
#import <AFNetworking/AFNetworking.h>


@implementation NetWork

+ (void)reportGeneralizeUid:(NSString *)uid handler:(void(^)(NSInteger status))handler{
    if (uid && uid.length > 0) {
        [self POST:@"reportGeneralizeUid" param:@{@"uid":uid} handler:^(id response, NSInteger code) {
            if (handler) {
                handler(0);
            }
        }];
    }
}

+ (void)getGeneralizeCountUid:(NSString *)uid handler:(void(^)(NSInteger count))handler {
    if (uid && uid.length > 0) {
        [self GET:@"getGeneralizeCount" param:@{@"uid":uid} handler:^(id response, NSInteger code) {
            NSInteger c = 0;
            if (response) {
                c = [response[@"count"] integerValue];
            }
            if (handler) {
                handler(c);
            }
        }];
    }else{
        if (handler) {
            handler(0);
        }
    }
}
+ (void)getRoomId:(void(^)(NSString *roomId))handler {
    [self GET:@"getRoomId" param:nil handler:^(id response, NSInteger code) {
        NSString *c = nil;
        if (response) {
            c = [NSString stringWithFormat:@"%@",response[@"room_id"]];
        }
        if (handler) {
            handler(c);
        }
    }];
}

+ (void)enterRoom:(NSDictionary *)param handler:(void(^)(NSInteger status,NSString *desc))handler {
    if (param) {
        [self POST:@"enterRoom" param:param handler:^(id response, NSInteger code) {
            if (response) {
                if (handler) {
                    NSInteger status2 = [response[@"status"] integerValue];
                    handler(status2,response[@"desc"]);
                }
            }
        }];
    }
}
+ (void)getRoomMembers:(NSString *)roomId handler:(void(^)(NSArray *userArray,NSInteger status))handler {
    if (roomId) {
        [self GET:@"getRoomMembers" param:@{@"room_id":roomId} handler:^(id response, NSInteger code) {
            if (response) {
                if (handler) {
                    NSArray *users = response[@"users"];
                    NSInteger status2 = [response[@"status"] integerValue];
                    handler(users,status2);
                }
            }else{
                if (handler) {
                    handler(nil,code);
                }
            }
        }];
    }
}

+ (void)getGroupId:(void(^)(NSString *groupId))handler {
    [self GET:@"getGroupId" param:nil handler:^(id response, NSInteger code) {
        NSString *c = nil;
        if (response) {
            c = [NSString stringWithFormat:@"%@",response[@"group_id"]];
        }
        if (handler) {
            handler(c);
        }
    }];
}

+ (void)enterGroup:(NSDictionary *)param handler:(void(^)(NSInteger status,NSString *desc))handler {
    if (param) {
        [self POST:@"enterGroup" param:param handler:^(id response, NSInteger code) {
            if (response) {
                if (handler) {
                    NSInteger status2 = [response[@"status"] integerValue];
                    handler(status2,response[@"desc"]);
                }
            }
        }];
    }
}

+ (void)getGroupMembers:(NSString *)groupId handler:(void(^)(NSArray *userArray,NSInteger status))handler {
    if (groupId) {
        [self GET:@"getGroupMembers" param:@{@"group_id":groupId} handler:^(id response, NSInteger code) {
            if (response) {
                if (handler) {
                    NSArray *users = response[@"users"];
                    NSInteger status2 = [response[@"status"] integerValue];
                    handler(users,status2);
                }
            }else{
                if (handler) {
                    handler(nil,code);
                }
            }
        }];
    }
}

// get请求
+ (void)GET:(NSString *)url param:(NSDictionary *)param handler:(void(^)(id response,NSInteger code))handler {
    NSString *urlString =[NSString stringWithFormat:@"%@/%@",JMLink_URL_API,url];
    NSLog(@"http get request:%@，param:%@",urlString,param);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    [manager GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"http get response:%@", responseObject);
            if (handler) {
                handler(responseObject,0);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"http get response,error:%@", error);
            if (handler) {
                handler(nil,error.code);
            }
        });
    }];
}

// post请求
+ (void)POST:(NSString *)url param:(NSDictionary *)param handler:(void(^)(id response,NSInteger code))handler  {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",JMLink_URL_API,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"http post request:%@,%@",urlString,param);
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"http post response:%@", responseObject);
            if (handler) {
                handler(responseObject,0);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"http post response,error:%@", error);
            if (handler) {
                handler(nil,error.code);
            }
        });
    }];
}

+ (NSString *)toJsonString:(id)param {
    NSError *error = nil;
    if (!self) {
        NSLog(@"object is nil, giveup toJsonString");
        return nil;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *) self;
    }
    
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"Invalid json data is tried to transfer to string.");
        return nil;
    }
    
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:options
                                                     error:&error];
    if (data.length > 0 && error == nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"transfer jsonData to string failed with error: %@", error.userInfo);
        return nil;
    }
}
@end
