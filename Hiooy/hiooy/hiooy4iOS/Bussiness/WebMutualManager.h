//
//  WebMutualManager.h
//  KKMYForU
//
//  Created by 黄磊 on 14-1-13.
//  Copyright (c) 2014年 黄磊. All rights reserved.
//  用于处理与网页之间的交互...<未使用>

#import <Foundation/Foundation.h>

// web事件处理方式
typedef enum {
    kWebOpenView  = 0,                  // 在平台层打开对应界面
    kWebFetchData,                      // 从平台层获取数据
    kWebSendData,                       // 向平台层发送数据
    kWebShowAlert,                      // 显示alert弹窗
    kWebShowToast,                      // 显示toast
    kWebStartLoading,                   // 显示loading界面
    kWebStopLoading,                    // 关闭loading界面
    kWebCopyText                        // web需要拷贝文本到剪切板
} WebActionHandleMode;

// 显示商户详情
@protocol WebActionDelegate <NSObject>

@required
- (UIWebView *)webView;

@end


@interface WebMutualManager : NSObject

+ (WebMutualManager *)shareInstant;

- (void)handleThisRequest:(NSString *)requestId withDelegate:(id<WebActionDelegate>)delegate;


@end
