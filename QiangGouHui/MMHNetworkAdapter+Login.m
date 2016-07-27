//
//  MMHNetworkAdapter+Login.m
//  QiangGouHui
//
//  Created by 姚驰 on 16/7/3.
//  Copyright © 2016年 SoftBank. All rights reserved.
//

#import "MMHNetworkAdapter+Login.h"
#import "MMHAccount.h"
#import "MMHAccountSession.h"

@implementation MMHNetworkAdapter (Login)


- (void)loginWithPhoneNumber:(NSString *)phoneNumber passCode:(NSString *)passCode from:(id)requester succeededHandler:(void(^)(MMHAccount *account))succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"username": phoneNumber, @"loginPass": passCode};
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_login_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        MMHAccount *account = [[MMHAccount alloc] initWithJSONDict:[responseJSONObject objectForKey:@"info"]];
        [[MMHAccountSession currentSession] accountDidLogin:account];
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLoginNotification object:nil];
        succeededHandler(account);
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)logoutWithRequester:(id)requester succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"userToken": [[MMHAccountSession currentSession] token]};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_logout_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        [[MMHAccountSession currentSession] logoutWithCompletion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:MMHUserDidLogoutNotification object:nil];
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)resetPasswordFrom:(id)requester phone:(NSString *)phone pwd:(NSString *)pwd verifyCode:(NSString *)verifyCode succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSDictionary *parameters = @{@"mobile": phone, @"loginPass": pwd, @"code": verifyCode};
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_set_pwd_003" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


- (void)registerFrom:(id)requester loginType:(QGHLoginType)type phone:(NSString *)phone pwd:(NSString *)pwd verifyCode:(NSString *)verifyCode thirdId:(NSString *)thirdId thirdToken:(NSString *)thirdToken succeededHandler:(void(^)())succeededHandler failedHandler:(MMHNetworkFailedHandler)failedHandler {
    NSMutableDictionary *parameters = [@{@"mobile": phone, @"loginPass": pwd, @"code": verifyCode} mutableCopy];
    NSDictionary *thirdLoginDict = nil;
    if (type == QGHLoginTypeQQ) {
        thirdLoginDict = @{@"qq": thirdId, @"qqtoken": thirdToken};
    } else if (type == QGHLoginTypeWeChat) {
        thirdLoginDict = @{@"wechat": thirdId, @"wechattoken": thirdToken};
    }
    if (thirdLoginDict) {
        [parameters addEntriesFromDictionary:thirdLoginDict];
    }
    [parameters addEntriesFromDictionary:thirdLoginDict];
    
    MMHNetworkEngine *engine = [MMHNetworkEngine sharedEngine];
    [engine postWithAPI:@"_register_001" parameters:parameters from:requester responseObjectClass:nil responseObjectKeyMap:nil succeededBlock:^(id responseObject, id responseJSONObject) {
        succeededHandler();
    } failedBlock:^(NSError *error) {
        failedHandler(error);
    }];
}


@end
