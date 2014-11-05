//
//  UserManager.h
//  hiooy
//
//  Created by 黄磊 on 14-3-21.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResModel.h"
#import "UserInfoModel.h"

typedef void (^UserManagerBlock)(BOOL isSucceed, NSString *message);


@interface UserManager : NSObject

// 用户是否登录
@property (nonatomic, assign) BOOL isLogin;

+ (UserManager *)shareInstant;

- (NSString *)getMemberId;

- (NSString *)getUserName;

- (UserInfoModel *)getUserCenterInfo;

#pragma mark - UserLogin
/**
 *	@brief	用户登录接口，实现用户的登录
 *
 *	@param 	userName  用户名
 *	@param 	psw  密码
 *	@param 	completion 	登录成功或失败后的回调
 *
 *	@return	no return
 */
// 登录
// type 1-手机 2-邮箱
- (void)userLogin:(NSString *)userName
     withPassword:(NSString *)psw
          andType:(NSString *)type
       completion:(UserManagerBlock)completion;

// 注册
- (void)userRegister:(NSString *)userName
        withPassword:(NSString *)psw
           andVerify:(NSString *)verify
          completion:(UserManagerBlock)completion;

// 登出
- (void)userLogout:(NSString *)userName
      withPassword:(NSString *)psw
        completion:(UserManagerBlock)completion;

// 修改密码
- (void)userChangePassword:(NSString *)oldPsw
           withNewPassword:(NSString *)newPsw
                completion:(UserManagerBlock)completion;

// 找回密码
- (void)userGetPassword:(NSString *)loginName
             withVerify:(NSString *)code
            andPasswrod:(NSString *)password
             completion:(UserManagerBlock)completion;

// 会员中心
- (void)userCenter:(NSString *)userName
        completion:(UserManagerBlock)completion;

// 获取短信验证码
// type: 1-注册 2-忘记密码
- (void)userGetVerifyCode:(NSString *)mobile
                 withType:(NSString *)type
               completion:(UserManagerBlock)completion;


@end
