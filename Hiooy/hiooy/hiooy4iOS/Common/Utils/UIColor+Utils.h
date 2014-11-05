//
//  UIColor+Utils.h
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2012年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (UIColor_HexRGB)

/**
 *	@brief	RGB值转换为UIColor对象
 *
 *	@param 	inColorString 	RGB值，如“＃808080”这里只需要传入“808080”
 *
 *	@return	UIColor对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
