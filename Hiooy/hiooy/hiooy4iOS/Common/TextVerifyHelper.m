//
//  TextVerifyHelper.m
//  Lottery
//
//  Created by Xia Zhiyong on 13-11-11.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "TextVerifyHelper.h"

@implementation TextVerifyHelper

#define NUMBERS @"0123456789"
#define EMAIL @"@." // 邮箱中一定有@和.<暂不考虑.>

+ (BOOL)checkContent:(NSString *)message {
    
    if (message == nil || [message isEqualToString:@""] == YES) {
        return NO;
    }
    
    NSString *msg = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (msg == nil || [msg isEqualToString:@""] == YES) {
        return NO;
    }
    
    return YES;
    
}

// 判断是否为纯数字
+ (BOOL)checkNumber:(NSString *)string
{
    // 采用自定义的字符集来进行判断,灵活性大...<可加入其它符号>
    //string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 非数字字符集
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];  // YES:表示为纯数字<无其它类型字符可以去掉> NO:表示为非纯数字
}

// 判断是否为纯数字
+ (BOOL)checkNumber2:(NSString *)string
{
    // 采用去掉数字字符的方式
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;  // 去掉所有数字后,若长度仍大于0,则表示必有一个字符不为数字
    }
    else
    {
        return YES;
    }
}

// 判断是否为邮箱
+ (BOOL)checkEmailType:(NSString *)string
{
    // 采用去掉@字符的方式
    //NSString *filtered = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:EMAIL]];
    NSString *filtered = [string stringByReplacingOccurrencesOfString:@"@" withString:@""];
    NSLog(@"%@, %@", string, filtered);
    return ![string isEqualToString:filtered];   // YES:表示无@字符 NO:表示有@字符(去掉@后,一定不相同)
}

// 检测账号是1手机号(纯数字) or 2邮箱(带@符号) or 0其它
+ (int)checkAccountType:(NSString *)account {
    
    int flag = 0;   // 默认为其它
    
    BOOL isNumber = [self checkNumber:account];
    if (isNumber == YES)
    {
        return 1;
    }
    else
    {
        BOOL hasEmailFalg = [self checkEmailType:account];
        if (hasEmailFalg == YES)
        {
            return 2;
        }
    }
    
    return flag;
    
}

+ (BOOL)checkPhone:(NSString *)phoneNumber {
    
    //手机号以13,15,18开头, 八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:phoneNumber];
    
}

+ (BOOL)checkMailAddress:(NSString *)mailAddress {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mailAddress];
    
}

+ (BOOL)checkUserName:(NSString *)userName {
    
    NSString *nameRegex = @"^[A-Z0-9a-z]+$"; // @"^\D[A-Z0-9a-z]+$"
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:userName];
    
}

+ (BOOL)checkUserCode:(NSString *)userCode {
    
    
    return YES;
    
}

// 身份证
+ (BOOL)checkIDCardNumber:(NSString *)idCard
{
    
    //NSString *IDRegex = @"^\d{15}|\d{18}$";
    NSString *IDRegex = @"(^\d{15}$)|(^\d{17}([0-9]|X)$)";
    NSPredicate *IDTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDRegex];
    return [IDTest evaluateWithObject:idCard];
    
}

// 银行卡号
+ (BOOL)checkBankAccount:(NSString *)cardNumber
{
    
    
    return YES;
}

+ (BOOL)beginWithNums:(NSString *)str
{
    for (int i=0;i<9;i++)
    {
        if([str hasPrefix:[NSString stringWithFormat:@"%d",i]])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)onlyContainChineseCharacters:(NSString *)str
{
    NSString *strRegex = @"^[\u4e00-\u9fa5]{2,5}+$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [pre evaluateWithObject:str];
}


// 为了便于RTLabel进行特殊显示
// 此RTLabel继承自view,而不是label,无法准确进行高度自适应。。。
+ (NSString *)transferToHTMLString:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    
    //NSString *oriStr = [str stringByReplacingOccurrencesOfString:@"(" withString:@"(<font face=AmericanTypewriter size=12 color='#376e00'>"];
    NSString *oriStr = [str stringByReplacingOccurrencesOfString:@"(" withString:@"(<font size=12 color='#376e00'>"];
    NSString *resStr = [oriStr stringByReplacingOccurrencesOfString:@")" withString:@"</font>)"];
    return resStr;
    
}

// 为了便于CustomLabel进行特殊显示
// 此CustomLabel不可自定义颜色,且不可调整字体大小,弃之不用。。。
+ (NSString *)transferToHTMLStringForCustomLabel:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    
    NSString *oriStr = [str stringByReplacingOccurrencesOfString:@"(" withString:@"(<font color=\"blue\">"];
    NSString *resStr = [oriStr stringByReplacingOccurrencesOfString:@")" withString:@"<font color=\"black\">)"];
    return resStr;
    
}

+ (NSString *)transferToHTMLStringForWebview:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableString *myStr = [[NSMutableString alloc] initWithFormat:@"<font size=2>%@</font>", str];
    NSString *oriStr = [myStr stringByReplacingOccurrencesOfString:@"(" withString:@"(<font size=2 color='#376e00'>"];
    NSString *resStr = [oriStr stringByReplacingOccurrencesOfString:@")" withString:@"</font>)"];
    
    return resStr;
    
}

// 获取所有赔率在字符串中的range
// 此AttributedLabel不可自定义颜色,且不可换行,弃之不用。。。
+ (NSMutableArray *)getAllRateRange:(NSString *)str {
    
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //    // 第一个括号内的赔率
    //    NSRange leftRange = [str rangeOfString:@"("];
    //    NSRange rightRange = [str rangeOfString:@")"];
    //    NSRange myRange = NSMakeRange(leftRange.location+1, rightRange.location-leftRange.location-1);
    
    int location = 0;
    int length = 0;
    //NSLog(@"rateString:%@", str);
    
    for (int i = 0; i < str.length; i++) {
        
        NSString *s = [str substringWithRange:NSMakeRange(i, 1)];
        
        if ([s isEqualToString:@"("]) {
            location = i;
            continue;
        }
        
        if ([s isEqualToString:@")"]) {
            length = i - location -1;
            NSRange myRange = NSMakeRange(location+1, length);
            [arr addObject:NSStringFromRange(myRange)];
            // 重置
            location = 0;
            length = 0;
            continue;
        }
        
    }
    
    return [arr autorelease];
    
}



#pragma mark - Add

// 检测邮箱
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 检测手机号
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

// 检测车牌号
+ (BOOL)isValidateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

// 判断是否为整形
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

// 判断是否为浮点形
+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//if( ![self isPureFloat:self.textRate.text] && ![self isPureInt:self.textRate.text])
//{
//    [tooles MsgBox:@"警告:含非法字符,请输入纯数字！"];
//    self.textRate.text = NULL;
//    return;
//}




@end
