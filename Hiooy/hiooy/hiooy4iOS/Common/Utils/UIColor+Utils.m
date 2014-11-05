//
//  UIColor+Utils.m
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2012年 Xia Zhiyong. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor(UIColor_HexRGB)


+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor colorWithRed: (float)redByte / 0xff green: (float)greenByte/ 0xff blue: (float)blueByte / 0xff alpha:1.0];    
    return result;
}

@end
