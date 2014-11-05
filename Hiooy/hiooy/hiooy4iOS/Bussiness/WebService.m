//
//  WebService.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "WebService.h"
#import "MBProgressHUD.h"
#import "DeviceHelper.h"
#import "ServerAction.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "ResultModel.h"


extern NetworkStatus g_reachableState;

static NSString *requestString = nil;

@interface WebService ()

+ (RespondModel *)getResultWithString:(NSString *)aString
                       returnClass:(Class)returnClass
                          andError:(NSError**)err;


@end

// https://github.com/AFNetworking/AFNetworking


@implementation WebService

#pragma mark - Test

// 不再使用，未加data=
// Post Test
+ (void)RequestTest:(NSString *)action
              param:(NSDictionary *)param
        returnClass:(Class)returnClass
            success:(RequestSuccessBlock)sblock
            failure:(RequestFailureBlock)fblock
{
    
    if (g_reachableState == NotReachable)
    {
        NSError *err = [[[NSError alloc] initWithDomain:kNetworkErrorMsg code:-1000 userInfo:nil] autorelease];
        if (fblock)
        {
            fblock(nil, err);
        }
        return;
    }
    
    // 拼接请求url
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@", kBaseUrl, action];
    LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
    LogInfo(@"...>>>...requestData:%@\n", [param convertToJsonString]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:pathUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"...>>>JSON: %@", responseObject);
        //NSString *resultStr = operation.responseString;
        //NSLog(@"result string:%@", resultStr);
        NSDictionary *respond = (NSDictionary *)responseObject;
        sblock(operation, respond);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"...>>>Error: %@", error);
        fblock(operation, nil);
    }];
    
}

// Post Test
+ (void)RequestTest2:(NSString *)action
               param:(NSString *)param
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock
{
    
    if (g_reachableState == NotReachable)
    {
        NSError *err = [[[NSError alloc] initWithDomain:kNetworkErrorMsg code:-1000 userInfo:nil] autorelease];
        if (fblock)
        {
            fblock(nil, err);
        }
        return;
    }
    
    // 拼接请求url
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@", kBaseUrl, action];
    LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
    LogInfo(@"...>>>...requestData:%@\n", param);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:pathUrl]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:30.0];
    if (param != nil)
    {
        // 传递的参数
        NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
        // 设置Method
        [request setHTTPMethod:@"POST"];
        // 装载内容
        [request setHTTPBody:postData];
    }
    
    //Add your request object to an AFHTTPRequestOperation
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"...>>>JSON: %@", responseObject);
        //NSDictionary *respond = (NSDictionary *)responseObject;
        
//        ResultModel *result = [[ResultModel alloc] initWithString:operation.responseString error:nil];
//        if ([result.data isKindOfClass:[NSString class]] == YES)
//        {
//            NSLog(@"data is string");
//        }
//        else if ([result.data isKindOfClass:[NSDictionary class]] == YES)
//        {
//            NSLog(@"data id dic");
//        }
//        else
//        {
//            NSLog(@"data is other type");
//        }
        
        NSString *respondStr = operation.responseString;
        NSLog(@"respondString:%@", respondStr);
        // 若无返回数据,则请求错误...
        if (respondStr == nil || [respondStr isEqualToString:@""] == YES)
        {
            fblock(operation, nil);
            return;
        }
        
        // jsonkit...<json string转dic，未使用jsonmodel>
        NSData *respondData = [respondStr dataUsingEncoding:NSUTF8StringEncoding];
//        id respond = [respondData objectFromJSONData];
//        if ([respond isKindOfClass:[NSArray class]] == YES)
//        {
//            NSLog(@"返回数组...~!@");
//            // 只针对获取地区信息接口返回数据
//            NSDictionary *respondDic = [NSDictionary dictionaryWithObjectsAndKeys:(NSArray *)respond, @"data", @"success", @"status", @"", @"msg", nil];
//            sblock(operation, respondDic);
//            return;
//        }
        NSDictionary *respondDic = (NSDictionary *)[respondData objectFromJSONData];
        NSLog(@"status:%@, msg:%@, data:%@", [respondDic objectForKey:@"status"], [respondDic objectForKey:@"msg"], [respondDic objectForKey:@"data"]);
        NSString *status = (NSString *)[respondDic objectForKey:@"status"];
        if (status == nil || [status isEqualToString:@""] == YES)
        {
            fblock(operation, nil);
            return;
        }
        sblock(operation, respondDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"...>>>Error: %@", error);
        fblock(operation, nil);
    }];
    
    [operation start];
    
}


+ (void)RequestTest3:(NSString *)action
              param:(NSDictionary *)param
{
    NSString *keystr = @"data=";
    //NSString *valuestr = @"{\"uname\":\"zhxyxyz\",\"password\":\"65131874\"}";
    NSString *valuestr = @"{\"uname\":\"13005145815\",\"password\":\"058717\"}";
    NSString *requestString = [keystr stringByAppendingString:valuestr];
    
    NSLog(@"requestString:%@",requestString);
    
    // http://linux.hiooy.com/ecstore/index.php/wap/passport-post_login.html
    NSURL *url = [[NSURL alloc]initWithString:@"http://linux.hiooy.com/ecstore/index.php/wap/passport-post_login.html"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    NSData *body = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    
    //[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];;//调用webservice必须添加
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"resultStr:%@",resultStr);
}


/*
 
 //具体的后台服务地址
 static NSString *const BaseURLString = @"www.xx.com/";
 
 // 用法一
 
NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:BaseURLString]];
//用于存放需要传递给服务端的参数
NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
[parameters setObject:@"参数值" forKey:@"参数名"];
AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
[client setDefaultHeader:@"Accept" value:@"application/json"];

NSString *path = @"具体的服务端处理接口";//例如restful的"xx/yy/zz"

// 发送请求。可以使用getPath来获取数据，也可以用postPath来更新服务器数据，这里只列举了post的用法，get与post的写法类似。
[client postPath:path
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //交互成功:responseObject包含了从服务器回传的信息
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             //交互失败:error记录了具体的错误信息
             UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"获取数据失败"
                                                          message:error
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
             [av show];
         }
 ];

// 用法二（operation的方式）

NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURLString,@"具体的服务端处理接口"]];
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:baseURL
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:20.0f];
//传递的参数
NSString *postString = @"keywords=嘟囔";
NSStringEncoding enc = NSUTF8StringEncoding;
NSData *postData = [postString dataUsingEncoding: enc allowLossyConversion: YES];

//设置Method
[request setHTTPMethod: @"POST"];

//装载内容
[request setHTTPBody:postData];

AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
{
    //交互成功:JSON包含了从服务器回传的信息
    
} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
{
    //交互失败:error记录了具体的错误信息
    NSLog(@"ERROR: %@", error);
    
}];

[operation start];

 */




#pragma mark - 发起GET请求

/*
 // GET Request
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */

// Get
+ (void)startGetRequest:(NSString *)action
                body:(NSString *)body
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock
{
    // 本地数据测试
    
    // 网络状态检查
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusNotReachable
            || status == AFNetworkReachabilityStatusUnknown) {
            return;
        }else {
            // AFNetworkReachabilityStatusReachableViaWiFi
            // AFNetworkReachabilityStatusReachableViaWWAN
            
            // 开始发送请求
            
            // 拼接请求url
            NSString *server = [[ServerAction shareInstant] objectForKey:action];
            NSString *pathUrl = [NSString stringWithFormat:@"%@/%@/%@.do", kBaseUrl, server, action];
            LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
            LogInfo(@"...>>>...requestData:%@\n", body);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:pathUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
            }];
        }
        /*
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //[operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:    // AFNetworkReachabilityStatusUnknown
                //[operationQueue setSuspended:YES];
                break;
        }   
        */
    }];
}


#pragma mark - 发起POST请求

/*
 // POST URL-Form-Encoded Request
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 NSDictionary *parameters = @{@"foo": @"bar"};
 [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */

/*
 // POST Multi-Part Request
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 NSDictionary *parameters = @{@"foo": @"bar"};
 NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
 [manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:filePath name:@"image" error:nil];
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"Success: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */

// Post
+ (void)startRequest:(NSString *)action
                body:(NSString *)body
         returnClass:(Class)returnClass
             success:(RequestSuccessBlock)sblock
             failure:(RequestFailureBlock)fblock
{
    
    // 开发时使用本地数据，如需使用网络数据，请在Constant.h中注掉该定义
#ifdef USELOCALDATA
    NSString *receiveStr = (NSString *)[[[LocalData shareInstant] objectForKey:action] objectForKey:@"receive"];
    LogInfo(@"...>>>...received data:%@", receiveStr);
    NSError *err = nil;
    ResultModel *result = nil;
    if (receiveStr)
    {
        result = [WebService getResultWithString:receiveStr
                                     returnClass:returnClass
                                        andError:&err];
    }
    if (err)
    {
        // 数据解析错误，出现该错误说明与服务器接口对应出了问题
        LogDebug(@"JSON Parse Error: %@\n", err);
        if (fblock)
        {
            fblock(nil, err);
        }
    }
    else
    {
        if (result)
        {
            if (sblock)
            {
                sblock(nil, result);
            }
        }
        else
        {
            err = [[NSError alloc] initWithDomain:@"本地没有保存该接口的假数据" code:-1000 userInfo:nil];
            if (fblock)
            {
                fblock(nil, err);
            }
        }
    }
    return;
#endif
    
    if (g_reachableState == NotReachable)
    {
        NSError *err = [[[NSError alloc] initWithDomain:kNetworkErrorMsg code:-1000 userInfo:nil] autorelease];
        if (fblock)
        {
            fblock(nil, err);
        }
        return;
    }
    
    // 拼接发送数据
    NSDictionary *aSendDic = [self getWholeRequestData:body];
    
    // 拼接请求url
//    NSString *server = [[ServerAction shareInstant] objectForKey:action];
//    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@/%@.do", kBaseUrl, server, action];
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@", kBaseUrl, action];
    LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
    LogInfo(@"...>>>...requestData:%@\n", body);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:pathUrl parameters:aSendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
    /*
    CKHttpClient *httpClient = [CKHttpClient defaultHttpClient];
    [httpClient defaultValueForHeader:@"Accept"];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:pathUrl
                                                      parameters:aSendDic];
    [request setTimeoutInterval:30];
    
    //Add your request object to an AFHTTPRequestOperation
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc]
                                          initWithRequest:request] autorelease];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         // 请求成功
         NSString *response = [operation responseString];
         LogInfo(@"...>>>...receiveData = %@", response);
         NSError *err = nil;
         // 解析json
         ResultModel *result = [WebService getResultWithString:response
                                                 returnClass:returnClass
                                                    andError:&err];
         
         //sblock(response);
         if (err)
         {
             // 数据解析错误，出现该错误说明与服务器接口对应出了问题
             LogDebug(@"...>>>...JSON Parse Error: %@\n", err);
             if (fblock)
             {
                 fblock(nil, err);
             }
             
         }
         else
         {
             if (sblock)
             {
                 sblock(operation, result);
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         // 请求失败
         LogError(@"...>>>...Network error: %@\n", [operation error]);
         if (fblock)
         {
             fblock(operation, error);
         }
         
     }];
    
    //call start on your request operation
    [operation start];
    */
}


/*
 // Creating an Upload Task
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
 
 NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
 NSURLRequest *request = [NSURLRequest requestWithURL:URL];
 
 NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
 NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"Success: %@ %@", response, responseObject);
 }
 }];
 [uploadTask resume];
 */

/*
 // Creating an Upload Task for a Multi-Part Request, with Progress
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
 } error:nil];
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 NSProgress *progress = nil;
 
 NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 
 [uploadTask resume];
 */

// Post file
+ (void)startRequestForUpload:(NSString *)action
                         body:(NSString *)body
                     filePath:(NSString *)path
                  returnClass:(Class)returnClass
                      success:(RequestSuccessBlock)sblock
                      failure:(RequestFailureBlock)fblock
{
    if (g_reachableState == NotReachable)
    {
        NSError *err = [[[NSError alloc] initWithDomain:kNetworkErrorMsg code:-1000 userInfo:nil] autorelease];
        if (fblock)
        {
            fblock(nil, err);
        }
        return;
    }

    // 拼接发送数据
    NSDictionary *aSendDic = [self getWholeRequestData:body];
    
    // 拼接请求url
    NSString *server = [[ServerAction shareInstant] objectForKey:action];
    NSString *pathUrl = [NSString stringWithFormat:@"%@/%@/%@.do", kBaseUrl, server, action];
    LogTrace(@"...>>>...requestUrl:%@\n", pathUrl);
    LogInfo(@"...>>>...requestData:%@\n", body);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:pathUrl parameters:aSendDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image1.jpg"] name:@"file" fileName:@"filename1.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
        }
    }];
    
    [uploadTask resume];

    /*
    CKHttpClient *httpClient = [CKHttpClient defaultHttpClient];
    [httpClient defaultValueForHeader:@"Accept"];
    
    //    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
    //                                                            path:pathUrl
    //                                                      parameters:aSendDic];
    
    LogInfo(@"本地音频文件全路径:%@", path);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:pathUrl parameters:aSendDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        NSData *audioData = [NSData dataWithContentsOfFile:path];
                                        //[formData appendPartWithFileData:audioData name:[[path lastPathComponent] stringByDeletingPathExtension] fileName:[path lastPathComponent] mimeType:@"audio/speex"];
                                        [formData appendPartWithFileData:audioData name:@"fileData" fileName:[path lastPathComponent] mimeType:@"audio/speex"];
                                    }];
    
    //Add your request object to an AFHTTPRequestOperation
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc]
                                          initWithRequest:request] autorelease];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         // 请求成功
         NSString *response = [operation responseString];
         LogInfo(@"...>>>...receiveData = %@", response);
         NSError *err = nil;
         
         ResultModel *result = [WebService getResultWithString:response
                                                 returnClass:returnClass
                                                    andError:&err];
         
         //sblock(response);
         if (err)
         {
             // 数据解析错误，出现该错误说明与服务器接口对应出了问题
             LogDebug(@"...>>>...JSON Parse Error: %@\n", err);
             if (fblock)
             {
                 fblock(nil, err);
             }
         }
         else
         {
             if (sblock)
             {
                 sblock(operation, result);
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         // 请求失败
         LogError(@"...>>>...Network error: %@\n", [operation error]);
         if (fblock)
         {
             fblock(operation, error);
         }
         
     }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         LogInfo(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
    
    //call start on your request operation
    [operation start];
    */
}


/*
 // Creating a Download Task
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
 
 NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
 NSURLRequest *request = [NSURLRequest requestWithURL:URL];
 
 NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
 NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
 return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
 } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
 NSLog(@"File downloaded to: %@", filePath);
 }];
 [downloadTask resume];
 */

// download
+ (void)startDownload:(NSString *)remotePath
         withSavePath:(NSString *)localPath
              success:(RequestSuccessBlock)sblock
              failure:(RequestFailureBlock)fblock
{

    if (g_reachableState == NotReachable)
    {
        NSError *err = [[[NSError alloc] initWithDomain:kNetworkErrorMsg code:-1000 userInfo:nil] autorelease];
        if (fblock)
        {
            fblock(nil, err);
        }
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:remotePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        //return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL URLWithString:localPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //NSLog(@"File downloaded to: %@", filePath);
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            NSLog(@"File downloaded to: %@", filePath);
            
        }
    }];
    [downloadTask resume];
    
    /*
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:remotePath]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.0];
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"filename"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         LogInfo(@"...>>>...Successfully downloaded file to %@\n", localPath);
         if (sblock)
         {
             sblock(operation, nil);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         // 下载失败
         LogError(@"...>>>...Network error: %@\n", [operation error]);
         if (fblock)
         {
             fblock(operation, error);
         }
         // 删除下载的错误文件
         NSFileManager *fileHandler = [NSFileManager defaultManager];
         [fileHandler removeItemAtPath:localPath error:nil];
         
     }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         //下载进度
         float progress = (float)totalBytesRead / totalBytesExpectedToRead;
         //下载完成...该方法会在下载完成后立即执行
         if (progress == 1.0)
         {
             LogInfo(@"下载完成...");
         }
     }];
    
    [operation start];
    */
}


/*
 Batch of Operations
 NSMutableArray *mutableOperations = [NSMutableArray array];
 for (NSURL *fileURL in filesToUpload) {
 NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:fileURL name:@"images[]" error:nil];
 }];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 
 [mutableOperations addObject:operation];
 }
 
 NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:@[...] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
 NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
 } completionBlock:^(NSArray *operations) {
 NSLog(@"All operations in batch complete");
 }];
 [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
 */


/*
// 取消请求
+ (void)cancelRequest:(NSString *)m
{
    [[CKHttpClient defaultHttpClient] cancelAllHTTPOperationsWithMethod:@"GET" path:m];
    [[CKHttpClient defaultHttpClient] cancelAllHTTPOperationsWithMethod:@"POST" path:m];
}

// 取消所有的请求
+ (void)cancelAllRequest
{
    [[[CKHttpClient defaultHttpClient] operationQueue] cancelAllOperations];
}
*/


// 拼装 request data
+ (NSDictionary *)getWholeRequestData:(NSString *)requestBody
{
    // 拼接发送数据
    NSString *aSendData = [WebService getRequestString];
    aSendData = [aSendData stringByReplacingOccurrencesOfString:@"{body}" withString:requestBody];
    return [NSDictionary dictionaryWithObject:aSendData forKey:@"dataJson"];
}

+ (NSString *)getRequestString
{
    if (requestString == nil)
    {
        // 拼接发送数据
        NSString *aSendData = [[[NSMutableString alloc] initWithString:kSendData] autorelease];
        aSendData = [aSendData stringByReplacingOccurrencesOfString:@"{mac}" withString:@"\"45465768wrewrw\""];
        NSString *iOSVersion = [NSString stringWithFormat:@"\"%@\"", [DeviceHelper getCurrentIOSVersion]];
        NSString *imei = [NSString stringWithFormat:@"\"%@\"", [DeviceHelper getDeviceID]];
        NSLog(@"deviceID:%@", [DeviceHelper getDeviceID]);
        NSString *headerString = [kSendHeader stringByReplacingOccurrencesOfString:@"{terminalstate}" withString:kTerminalState];
        headerString = [headerString stringByReplacingOccurrencesOfString:@"{sysVersion}" withString:iOSVersion];
        headerString = [headerString stringByReplacingOccurrencesOfString:@"{imei}" withString:imei];
        aSendData = [aSendData stringByReplacingOccurrencesOfString:@"{head}"
                                                         withString:headerString];
        
        requestString = [[NSString alloc] initWithString:aSendData];
    }
    return requestString;
}

// 从字符串转换成ResultModel
+ (RespondModel *)getResultWithString:(NSString *)aString
                       returnClass:(Class)returnClass
                          andError:(NSError**)err
{
    
    @try {
        
        RespondModel *aRespond = [[[RespondModel alloc] initWithString:aString error:nil] autorelease];
        return aRespond;
        
        /*
        //NSDictionary *body = [[aRespond.body copy] autorelease];
        ResultModel *result = [[[ResultModel alloc] init] autorelease];
        result.status = [aRespond status];
        result.msg = [NSString stringWithString:aRespond.msg];
        result.data = aRespond.data;
        
        // 判断返回数据是否正常,先判断code和message即可
        if ([[body objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
        {   // result返回字典类型数据
            LogInfo(@"[NSDictionary class]");
            if ([body objectForKey:@"result"] && returnClass)
            {
                result.result = [[returnClass alloc] initWithDictionary:[body objectForKey:@"result"] error:err];
            }
        }
        else if ([[body objectForKey:@"result"] isKindOfClass:[NSString class]])
        { // result返回字串类型数据
            LogInfo(@"[NSString class]");
            if ([body objectForKey:@"result"] == nil || [[body objectForKey:@"result"] isEqualToString:@""] == YES)
            {
                result.result = nil;
            }
        }
        else if ([[body objectForKey:@"result"] isKindOfClass:[NSArray class]])
        {  // result返回数组类型数据
            LogInfo(@"[NSArray class]");
            if ([body objectForKey:@"result"] && returnClass)
            {
                NSArray *array = [body objectForKey:@"result"];
                LogInfo(@"count:%d\narray:%@", array.count, array);
                if (array != nil && array.count > 0)
                {
                    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < array.count; i++)
                    {
                        NSDictionary *dic = [array objectAtIndex:i];
                        [resultArr addObject:[[returnClass alloc] initWithDictionary:dic error:err]];
                    }   // for
                    result.result = resultArr;
                }
                else
                {
                    result.result = nil;
                }
            }
        }
        return result;
        */
        
    }
    @catch (NSException *exception)
    {
        LogDebug(@"%@", exception);
        *err = [[[NSError alloc] initWithDomain:exception.reason code:-500 userInfo:exception.userInfo] autorelease];
        return nil;
    }
    @finally {
        //
    }
    
}


/*
 NSString *keystr = @"data=";
 NSString *valuestr = @"{\"uname\":\"zhxyxyz\",\"password\":\"65131874\"}";
 NSString *requestString = [keystr stringByAppendingString:valuestr];
 
 NSLog(@"string:%@",requestString);
 
 NSURL *url = [[NSURL alloc]initWithString:@"http://linux.hiooy.com/ecstore/index.php/wap/passport-post_login.html"];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100];
 
 NSData * body = [requestString dataUsingEncoding:NSUTF8StringEncoding];
 
 //[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];;//调用webservice必须添加
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody:body];
 
 NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSString * resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"%@",resultStr);
 */



@end
