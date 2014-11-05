//
//  TextVerifyHelper.h
//  Lottery
//
//  Created by Xia Zhiyong on 13-11-11.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextVerifyHelper : NSObject

+ (BOOL)checkContent:(NSString *)message;            // 检验内容是否为空
+ (BOOL)checkNumber:(NSString *)string;              // 判断是否为纯数字
+ (BOOL)checkEmailType:(NSString *)string;           // 判断是否为邮箱<前期只判断是否带@符号>
+ (int)checkAccountType:(NSString *)account;         // 检测账号是1手机号(纯数字) or 2邮箱(带@符号) or 0其它
+ (BOOL)checkPhone:(NSString *)phoneNumber;          // 检验手机号
+ (BOOL)checkMailAddress:(NSString *)mailAddress;    // 检验邮箱地址
+ (BOOL)checkUserName:(NSString *)userName;          // 检验用户名<无下划线,只带英文与数字>[4-6位、不能以数字开头]
+ (BOOL)checkUserCode:(NSString *)userCode;          // 检验密码<字母或数字>[6-16位]
+ (BOOL)checkIDCardNumber:(NSString *)idCard;        // 检验身份证号
+ (BOOL)checkBankAccount:(NSString *)cardNumber;     // 检验银行卡号
+ (BOOL)beginWithNums:(NSString *)str;               // 判断是否以数字开头
+ (BOOL)onlyContainChineseCharacters:(NSString *)str;// 检测是否只包含中文字符
+ (NSString *)transferToHTMLString:(NSString *)str;  // 将指定字符串转成带html标签的字符串
+ (NSString *)transferToHTMLStringForCustomLabel:(NSString *)str;
+ (NSString *)transferToHTMLStringForWebview:(NSString *)str;
+ (NSMutableArray *)getAllRateRange:(NSString *)str;

@end
