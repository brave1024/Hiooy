//
//  XMLHelper.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-26.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "XMLHelper.h"
#import "GDataXMLNode.h"

@implementation XMLHelper

// 解析xml测试
+ (void)xmlParserTest
{
    
    //获取工程目录的xml文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testXML" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    /*
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noNSxml"];
    NSError *docError = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:&docError];
    if(!docError)
    {
        //
    }
    */
    
    /*
    // 基于xpath的解析
    NSArray *themeAttr = [doc nodesForXPath:@"//theme" error:&error];
    for(GDataXMLElement *themeElement in themeAttr) {
        // theme id
        GDataXMLNode *themeIDNode = [themeElement attributeForName:@"id"]; //解析属性
        int themeID = [themeIDNode.stringValue intValue];//数字
        //theme url
        GDataXMLNode *themeURLNode = [themeElement attributeForName:@"url"]; //字符串
        NSString *themeURL = themeURLNode.stringValue;
    }
    */
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //获取根节点下的节点（user）
    NSArray *users = [rootElement elementsForName:@"user"];
    
    for (GDataXMLElement *user in users) {
        //  user节点的id属性
        NSString *userId = [[user attributeForName:@"id"] stringValue];
        NSLog(@"user id is:%@", userId);
        
        // user节点的name属性
        GDataXMLElement *userName = [[user elementsForName:@"name"] objectAtIndex:0];
        NSString *name = [userName stringValue];
        NSLog(@"user name is:%@", name);
        
        // 获取addr节点的值
        GDataXMLElement *userAddr = [[user elementsForName:@"addr"] objectAtIndex:0];
        NSString *addr = [userAddr stringValue];
        NSLog(@"user address is:%@", addr);
        
        // 获取phone节点的值
        GDataXMLElement *userPhone = [[user elementsForName:@"phone"] objectAtIndex:0];
        // 获取telephone节点的值
        GDataXMLElement *userTel = [[userPhone elementsForName:@"telephone"] objectAtIndex:0];
        NSString *tel = [userTel stringValue];
        NSLog(@"user telephone is:%@", tel);
        
        // 获取mobile节点的值
        GDataXMLElement *userMobile = [[userPhone elementsForName:@"mobile"] objectAtIndex:0];
        NSString *mobile = [userMobile stringValue];
        NSLog(@"user mobile is:%@", mobile);
        
        NSLog(@"-------------------");
    }
     
}

// 生成xml测试
+ (void)createXMLTest
{
    
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"request"];
    
    for(int i = 0; i < 5; i++) {
        
        GDataXMLElement *userElement = [GDataXMLNode elementWithName:@"user"];
        
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"name" stringValue:@"夏志勇"];
        GDataXMLElement *areaElement = [GDataXMLNode elementWithName:@"area" stringValue:@"mainland:湖北/武汉市/洪山区:501"];
        GDataXMLElement *addrElement = [GDataXMLNode elementWithName:@"addr" stringValue:@"湖北武汉市洪山区168号"];
        GDataXMLElement *zcodeElement = [GDataXMLNode elementWithName:@"zipcode" stringValue:@"430070"];
        
        GDataXMLElement *phoneElement = [GDataXMLNode elementWithName:@"phone"];
        GDataXMLElement *telElement = [GDataXMLNode elementWithName:@"telephone" stringValue:@"86911013"];
        GDataXMLElement *mobileElement = [GDataXMLNode elementWithName:@"mobile" stringValue:@"18507103285"];
        
        [phoneElement addChild:telElement];
        [phoneElement addChild:mobileElement];
        
        [userElement addChild:nameElement];
        [userElement addChild:areaElement];
        [userElement addChild:addrElement];
        [userElement addChild:zcodeElement];
        [userElement addChild:phoneElement];
        
        [requestElement addChild:userElement];
        
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    
    // 设置使用的xml版本号
    [document setVersion:@"1.0"];
    // 设置xml文档的字符编码
    [document setCharacterEncoding:@"utf-8"];
    
    NSData *xmlData = document.XMLData;
    NSString *xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSLog(@"xml:%@", xmlString);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"testXML.xml"];
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Party" ofType:@"xml"];
    NSLog(@"Saving xml data to %@...", documentsPath);
    [xmlData writeToFile:documentsPath atomically:YES];
    
}

/*********************************************************/

// 注册
+ (NSString *)getRegisterXML:(RegisterReqModel *)reqData
{
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"request"];
    
    GDataXMLElement *licenseElement = [GDataXMLNode elementWithName:@"license" stringValue:reqData.license];
    
    GDataXMLElement *accountElement = [GDataXMLNode elementWithName:@"pam_account"];
    GDataXMLElement *loginNameElement = [GDataXMLNode elementWithName:@"login_name" stringValue:reqData.login_name];
    GDataXMLElement *passwordElement = [GDataXMLNode elementWithName:@"login_password" stringValue:reqData.login_password];
    GDataXMLElement *pswConfirmElement = [GDataXMLNode elementWithName:@"psw_confirm" stringValue:reqData.psw_confirm];
    
    GDataXMLElement *contactElement = [GDataXMLNode elementWithName:@"contact"];
    GDataXMLElement *mobileElement = [GDataXMLNode elementWithName:@"mobile" stringValue:reqData.mobile];
    GDataXMLElement *emailElement = [GDataXMLNode elementWithName:@"email" stringValue:reqData.email];
    GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"name" stringValue:reqData.name];
    
    [accountElement addChild:loginNameElement];
    [accountElement addChild:passwordElement];
    [accountElement addChild:pswConfirmElement];
    
    [contactElement addChild:mobileElement];
    [contactElement addChild:emailElement];
    [contactElement addChild:nameElement];
    
    [requestElement addChild:licenseElement];
    [requestElement addChild:accountElement];
    [requestElement addChild:contactElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    
    // 设置使用的xml版本号
    [document setVersion:@"1.0"];
    // 设置xml文档的字符编码
    [document setCharacterEncoding:@"utf-8"];
    
    NSString *xmlString = [[NSString alloc] initWithData:document.XMLData encoding:NSUTF8StringEncoding];
    NSLog(@"xml:%@", xmlString);
    return xmlString;
}
+ (void)parseRegisterXML:(RegisterResModel *)resData
{
    
    
}

// 登录
+ (NSString *)getLoginXML:(LoginReqModel *)reqData
{
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"request"];
    GDataXMLElement *unameElement = [GDataXMLNode elementWithName:@"uname" stringValue:reqData.uname];
    GDataXMLElement *passwordElement = [GDataXMLNode elementWithName:@"password" stringValue:reqData.password];
    [requestElement addChild:unameElement];
    [requestElement addChild:passwordElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    
    // 设置使用的xml版本号
    [document setVersion:@"1.0"];
    // 设置xml文档的字符编码
    [document setCharacterEncoding:@"utf-8"];
    
    NSString *xmlString = [[NSString alloc] initWithData:document.XMLData encoding:NSUTF8StringEncoding];
    NSLog(@"xml:%@", xmlString);
    return xmlString;
}
+ (void)parseLoginXML:(LoginResModel *)resData
{
    
    
    
}

// 收货地址
+ (NSString *)getAddressXML:(AddressItemModel *)reqData
{
    GDataXMLElement *requestElement = [GDataXMLNode elementWithName:@"request"];
    
    GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"name" stringValue:reqData.name];
    GDataXMLElement *areaElement = [GDataXMLNode elementWithName:@"area" stringValue:reqData.area_id];
    GDataXMLElement *addrElement = [GDataXMLNode elementWithName:@"addr" stringValue:reqData.addr];
    GDataXMLElement *zcodeElement = [GDataXMLNode elementWithName:@"zipcode" stringValue:reqData.zipcode];
    
    GDataXMLElement *phoneElement = [GDataXMLNode elementWithName:@"phone"];
    GDataXMLElement *telElement = [GDataXMLNode elementWithName:@"telephone" stringValue:reqData.telephone];
    GDataXMLElement *mobileElement = [GDataXMLNode elementWithName:@"mobile" stringValue:reqData.mobile];
    
    GDataXMLElement *defaultElement = [GDataXMLNode elementWithName:@"is_default" stringValue:reqData.is_default];
    
    [phoneElement addChild:telElement];
    [phoneElement addChild:mobileElement];
    
    [requestElement addChild:nameElement];
    [requestElement addChild:areaElement];
    [requestElement addChild:addrElement];
    [requestElement addChild:zcodeElement];
    [requestElement addChild:phoneElement];
    [requestElement addChild:defaultElement];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:requestElement];
    
    // 设置使用的xml版本号
    [document setVersion:@"1.0"];
    // 设置xml文档的字符编码
    [document setCharacterEncoding:@"utf-8"];
    
    NSData *xmlData = document.XMLData;
    NSString *xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSLog(@"xml:%@", xmlString);
    return xmlString;
}


@end
