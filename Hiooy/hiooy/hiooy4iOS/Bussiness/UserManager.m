//
//  UserManager.m
//  hiooy
//
//  Created by 黄磊 on 14-3-21.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "UserManager.h"
#import "WebService.h"
#import "JSONKit.h"

static UserManager *s_userManager = nil;


@interface UserManager ()

@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordEncrypt;
@property (nonatomic, copy) NSString *email;        // 手机注册用户无邮箱
@property (nonatomic, copy) NSString *type;         // 账号类型: 1-手机号 2-邮箱
@property (nonatomic, strong) LoginResModel *loginInfo;
@property (nonatomic, strong) UserInfoModel *userInfo;

// 个人中心接口返回的各状态下的订单数
//@property (nonatomic, copy) NSString *noPayNumber;      // 未会款
//@property (nonatomic, copy) NSString *noShipNumber;     // 未发货
//@property (nonatomic, copy) NSString *noReceiveNumber;  // 未收货
//@property (nonatomic, copy) NSString *noCommentNumber;  // 未评价

//- (void)test;

@end


@implementation UserManager

+ (UserManager *)shareInstant
{
    if (s_userManager == nil)
    {
        s_userManager = [[UserManager alloc] init];
    }
    return s_userManager;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self.isLogin = NO; // 初始化时为未登录状态
    }
    return self;
}


#pragma mark - GetUserInfo

// 获取用户id
- (NSString *)getMemberId
{
    return _memberId;
}

- (NSString *)getUserName
{
    return _loginName;
}

- (UserInfoModel *)getUserCenterInfo
{
    return _userInfo;
}


#pragma mark - Login & Register

// 登录
// type 1-手机 2-邮箱
- (void)userLogin:(NSString *)userName
     withPassword:(NSString *)psw
          andType:(NSString *)type
       completion:(UserManagerBlock)completion
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userName, @"uname",
                           type, @"type",
                           psw, @"password",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
//    [WebService RequestTest3:API_USER_LOGIN param:nil];
//    return;
    
    [WebService RequestTest2:API_USER_LOGIN
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // 只要为success,则表示一定已经是登录成功状态<不为error,则一定为success>
         {
             id data = [respond objectForKey:@"data"];
             // 判断data类型
             if ([data isKindOfClass:[NSString class]] == YES)
             {
                 NSString *dataStr = (NSString *)data;
                 if (dataStr == nil || [dataStr isEqualToString:@""] == YES || dataStr.length == 0)
                 {
                     completion(NO, @"登录异常");
                     //completion(YES, [respond objectForKey:@"msg"]);
                 }
                 else
                 {
                     // 登录成功后,必须有对应的返回值
                     JSONModelError *error = nil;
                     LoginResModel *login = [[LoginResModel alloc] initWithString:dataStr error:&error];
                     if (error)
                     {
                         completion(NO, @"登录数据解析失败");
                         //completion(YES, [respond objectForKey:@"msg"]);
                     }
                     else
                     {
                         // 保存登录信息<至内存>
                         self.loginInfo = login;
                         self.memberId = login.member_id;
                         self.loginName = [login.pam_account objectForKey:@"login_name"];
                         self.password = psw;
                         
                         // 保存用户信息<至本地>,便于下次app启动时自动登录
                         // 永远只保存并自动登录->最新登录成功的用户账号
                         [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
                         [[NSUserDefaults standardUserDefaults] setObject:psw forKey:kUserPsw];
                         [[NSUserDefaults standardUserDefaults] setObject:type forKey:kUserType];
                         [[NSUserDefaults standardUserDefaults] synchronize];

                         self.isLogin = YES;
                         self.type = type;
                         
                         completion(YES, @"登录成功");
                     }
                 }

             }
             else if ([data isKindOfClass:[NSDictionary class]] == YES)
             {
                 NSDictionary *dataDic = (NSDictionary *)data;
                 if (dataDic == nil)
                 {
                     completion(NO, @"登录异常");
                     //completion(YES, [respond objectForKey:@"msg"]);
                 }
                 else
                 {
                     // 登录成功后,必须有对应的返回值
                     JSONModelError *error = nil;
                     LoginResModel *login = [[LoginResModel alloc] initWithDictionary:dataDic error:&error];
                     if (error)
                     {
                         completion(NO, @"登录数据解析失败");
                         //completion(YES, [respond objectForKey:@"msg"]);
                     }
                     else
                     {
                         // 保存登录信息<至内存>
                         self.loginInfo = login;
                         self.memberId = login.member_id;
                         self.loginName = [login.pam_account objectForKey:@"login_name"];
                         self.password = psw;
                         
                         // 保存用户信息<至本地>,便于下次app启动时自动登录
                         // 永远只保存并自动登录->最新登录成功的用户账号
                         [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
                         [[NSUserDefaults standardUserDefaults] setObject:psw forKey:kUserPsw];
                         [[NSUserDefaults standardUserDefaults] setObject:type forKey:kUserType];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         self.isLogin = YES;
                         self.type = type;
                         
                         completion(YES, @"登录成功");
                     }
                 }
             }
             else
             {
                 // 其它类型
                 completion(NO, @"返回数据异常");
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"<error>...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 注册
- (void)userRegister:(NSString *)userName
        withPassword:(NSString *)psw
           andVerify:(NSString *)verify
          completion:(UserManagerBlock)completion
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"agree", @"license",
                           userName, @"login_name",
                           psw, @"login_password",
                           psw, @"psw_confirm",
                           verify, @"code",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_REGISTER
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else
         {
             //completion(YES, @"注册成功");
             
             id data = [respond objectForKey:@"data"];
             // 判断data类型
             if ([data isKindOfClass:[NSString class]] == YES)
             {
                 NSString *dataStr = (NSString *)data;
                 if (dataStr == nil || [dataStr isEqualToString:@""] == YES || dataStr.length == 0)
                 {
                     completion(NO, @"注册异常");
                 }
                 else
                 {
                     // 登录成功后,必须有对应的返回值
                     JSONModelError *error = nil;
                     RegisterResModel *userInfo = [[RegisterResModel alloc] initWithString:dataStr error:&error];
                     if (error)
                     {
                         completion(NO, @"注册数据解析失败");
                     }
                     else
                     {
                         // 注册成功后,即是登录状态
                         // 保存登录信息<至内存>
                         self.memberId = userInfo.member_id;
                         self.loginName = userInfo.login_name;
                         self.password = userInfo.psw_confirm;
                         //self.email = userInfo.email;
                         
                         // 保存用户信息<至本地>,便于下次app启动时自动登录
                         // 永远只保存并自动登录->最新登录成功的用户账号
                         [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
                         [[NSUserDefaults standardUserDefaults] setObject:psw forKey:kUserPsw];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         self.isLogin = YES;
                         
                         // 保存当前账号的注册信息
                         // 保存当前信息没有意义...!@
//                         NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                         [dic setObject:userInfo.login_name forKey:@"login_name"];
//                         [dic setObject:userInfo.login_password forKey:@"login_password"];
//                         [dic setObject:userInfo.email forKey:@"email"];
//                         [dic setObject:userInfo.member_id forKey:@"member_id"];
//                         [[NSUserDefaults standardUserDefaults] setObject:dic forKey:userInfo.login_name];
//                         [[NSUserDefaults standardUserDefaults] synchronize];
                         completion(YES, @"注册成功");
                     }
                 }
             }
             else if ([data isKindOfClass:[NSDictionary class]] == YES)
             {
                 NSDictionary *dataDic = (NSDictionary *)data;
                 if (dataDic == nil)
                 {
                     completion(NO, @"注册异常");
                 }
                 else
                 {
                     // 登录成功后,必须有对应的返回值
                     JSONModelError *error = nil;
                     RegisterResModel *userInfo = [[RegisterResModel alloc] initWithDictionary:dataDic error:&error];
                     if (error)
                     {
                         completion(NO, @"注册数据解析失败");
                     }
                     else
                     {
                         // 注册成功后,即是登录状态
                         // 保存登录信息<至内存>
                         self.memberId = userInfo.member_id;
                         self.loginName = userInfo.login_name;
                         self.password = userInfo.psw_confirm;
                         //self.email = userInfo.email;
                         
                         // 保存用户信息<至本地>,便于下次app启动时自动登录
                         // 永远只保存并自动登录->最新登录成功的用户账号
                         [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserName];
                         [[NSUserDefaults standardUserDefaults] setObject:psw forKey:kUserPsw];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         self.isLogin = YES;
                         
                         // 保存当前账号的注册信息
                         // 保存当前信息没有意义...!@
//                         NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                         [dic setObject:userInfo.login_name forKey:@"login_name"];
//                         [dic setObject:userInfo.login_password forKey:@"login_password"];
//                         [dic setObject:userInfo.email forKey:@"email"];
//                         [dic setObject:userInfo.member_id forKey:@"member_id"];
//                         [[NSUserDefaults standardUserDefaults] setObject:dic forKey:userInfo.login_name];
//                         [[NSUserDefaults standardUserDefaults] synchronize];
                         completion(YES, @"注册成功");
                     }
                 }
             }
             else
             {
                 // 其它类型
                 completion(NO, @"返回数据异常");
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 登出
- (void)userLogout:(NSString *)userName
      withPassword:(NSString *)psw
        completion:(UserManagerBlock)completion
{
    
    [WebService RequestTest2:API_USER_LOGOUT
                       param:nil
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // success
         {
             completion(YES, @"登出成功");
             self.isLogin = NO;     // 登录状态为no
             self.memberId = nil;   // memberid清空
             self.loginName = nil;
             self.password = nil;
             self.loginInfo = nil;
             
             // 清除账号信息
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserName];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPsw];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserType];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 修改密码
- (void)userChangePassword:(NSString *)oldPsw
           withNewPassword:(NSString *)newPsw
                completion:(UserManagerBlock)completion
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           oldPsw, @"old_passwd",
                           newPsw, @"passwd",
                           newPsw, @"passwd_re",
                           self.memberId, @"member_id", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_CHANGE_PSW
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // success
         {
             // 保存登录信息<至内存>
             self.password = newPsw;    // 替换旧密码
             
             // 保存用户信息<至本地>,便于下次app启动时自动登录
             // 永远只保存并自动登录->最新登录成功的用户账号
             [[NSUserDefaults standardUserDefaults] setObject:newPsw forKey:kUserPsw];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             completion(YES, @"修改密码成功");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 找回密码
- (void)userGetPassword:(NSString *)loginName
             withVerify:(NSString *)code
            andPasswrod:(NSString *)password
             completion:(UserManagerBlock)completion
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           loginName, @"login",
                           code, @"code",
                           password, @"new_password",nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_GET_PSW
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // success
         {
             //NSString *str = [NSString stringWithFormat:@"找回密码成功:%@", [respond objectForKey:@"msg"]];
             completion(YES, [respond objectForKey:@"msg"]);
             
             // 保存登录信息<至内存>
             self.password = password;    // 替换旧密码
             
             // 保存用户信息<至本地>,便于下次app启动时自动登录
             // 永远只保存并自动登录->最新登录成功的用户账号
             [[NSUserDefaults standardUserDefaults] setObject:password forKey:kUserPsw];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 会员中心
- (void)userCenter:(NSString *)userName
        completion:(UserManagerBlock)completion
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.memberId, @"member_id", nil];
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_CENTER
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // success
         {
             NSDictionary *dic = [respond objectForKey:@"data"];
             NSError *error = nil;
             self.userInfo = [[UserInfoModel alloc] initWithDictionary:dic error:&error];
             if (error)
             {
                 completion(NO, @"会员中心数据解析失败");
                 return;
             }
             completion(YES, @"获取会员中心信息成功");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}

// 获取短信验证码
- (void)userGetVerifyCode:(NSString *)mobile
                 withType:(NSString *)type
               completion:(UserManagerBlock)completion
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           mobile, @"mobile",
                           type, @"type", nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"data=%@", [param convertToJsonString]];
    NSLog(@"paramStr:%@", paramStr);
    
    [WebService RequestTest2:API_USER_MESSAGE_CODE
                       param:paramStr
                 returnClass:nil
                     success:^(AFHTTPRequestOperation *operation, NSDictionary *respond)
     {
         // When Completion
         NSLog(@"<status:%@, msg:%@>", [respond objectForKey:@"status"], [respond objectForKey:@"msg"]);
         NSString *status = [respond objectForKey:@"status"];
         if ([status isEqualToString:@"error"])
         {
             completion(NO, [respond objectForKey:@"msg"]);
         }
         else   // success
         {
             //NSString *str = [NSString stringWithFormat:@"找回密码成功:%@", [respond objectForKey:@"msg"]];
             completion(YES, [respond objectForKey:@"msg"]);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         LogError(@"...%@", error);
         completion(NO, @"请求失败");
     }];
}


@end
