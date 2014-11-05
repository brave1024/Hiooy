//
//  EditAddrViewController.m
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "EditAddrViewController.h"
#import "CountryModel.h"
#import "DocHelper.h"
#import "JSONKit.h"

@interface EditAddrViewController ()

@property (nonatomic, assign) BOOL isAdd;   // YES:添加 NO:编辑
@property (nonatomic, assign) CGRect viewRect;
@property (nonatomic, strong) CountryModel *country;
@property (nonatomic, copy) NSString *strArea;
@property (nonatomic, copy) NSString *strAreaId;

@end


@implementation EditAddrViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)242/255 blue:(CGFloat)242/255 alpha:1];
    
    self.scrollContent.backgroundColor = [UIColor clearColor];
    self.scrollContent.contentSize = CGSizeMake(320, 271);
    
    if (_curAddrInfo == nil)
    {
        // 添加
        _isAdd = YES;
        self.navigationItem.title = @"新增收货地址";
    }
    else
    {
        // 编辑
        _isAdd = NO;
        self.navigationItem.title = @"编辑收货地址";
        [_txtfieldName setText:_curAddrInfo.name];              // 姓名
        [_txtfieldMobile setText:_curAddrInfo.phone.mobile];    // 手机号
        [_txtfieldTel setText:_curAddrInfo.phone.tel];          // 座机号
        [_txtfieldZipcode setText:_curAddrInfo.zip];            // 邮编
        [_txtfieldRegion setText:_curAddrInfo.area];            // 区域
        [_txtfieldAddr setText:_curAddrInfo.addr];              // 地址
        // 给当前界面的区域和区域id赋值
        self.strArea = self.curAddrInfo.area;
        self.strAreaId = self.curAddrInfo.area_id;
    }
    
    [self.navController showBackButtonWith:self];
    
    // 添加或编辑
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 6, 42, 32);
    if (_isAdd) {
        [btnAdd setTitle:@"添加" forState:UIControlStateNormal];
    } else {
        [btnAdd setTitle:@"完成" forState:UIControlStateNormal];
    }
    [btnAdd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [btnAdd setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnAdd addTarget:self action:@selector(editOrAddAction) forControlEvents:UIControlEventTouchUpInside];
//    settingBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnAdd];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _viewRect = self.scrollContent.frame;
    
    arrayEdit = [[NSMutableArray alloc] initWithObjects:self.txtfieldName, self.txtfieldMobile, self.txtfieldTel, self.txtfieldZipcode, self.txtfieldAddr, nil];
    
    keyboardbar = [[KeyBoardTopBar alloc] init];
    [keyboardbar setAllowShowPreAndNext:YES];
    [keyboardbar setIsInNavigationController:NO];
    [keyboardbar setTextFieldsArray:arrayEdit];
    
    self.txtfieldName.inputAccessoryView = keyboardbar.view;
    self.txtfieldMobile.inputAccessoryView = keyboardbar.view;
    self.txtfieldTel.inputAccessoryView = keyboardbar.view;
    self.txtfieldZipcode.inputAccessoryView = keyboardbar.view;
    self.txtfieldAddr.inputAccessoryView = keyboardbar.view;
    
    [self requestAllArea];
    
    [self.pickerview selectRow:0 inComponent:0 animated:YES];
    [self.pickerview selectRow:0 inComponent:1 animated:YES];
    [self.pickerview selectRow:0 inComponent:2 animated:YES];
    
    // TEST
    //[self testForAddAddress];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 请求所有地区信息
- (void)requestAllArea
{
    // 先检查本地doc下是否有已经保存的地区数据
    NSString *localPath = [DocHelper getFilePathInDocDir:kAreaData];
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    if ([fileHandler fileExistsAtPath:localPath] == YES)
    {
        // 直接读取本地doc下保存的地区数据
        //NSArray *arrArea = [[NSArray alloc] initWithContentsOfFile:localPath];
        NSStringEncoding encoding = NSUTF8StringEncoding;
        NSString *strArea = [[NSString alloc] initWithContentsOfFile:localPath usedEncoding:&encoding error:nil];
        NSLog(@"doc中已有保存的地区数据,直接读取");
        //NSLog(@"%@", strArea);
        NSData *respondData = [strArea dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *respondDic = (NSDictionary *)[respondData objectFromJSONData];
        //NSLog(@"%@", respondDic);
        self.country = [[CountryModel alloc] initWithDictionary:respondDic error:nil];
        // 写文件到doc目录下
        NSString *localPath = [DocHelper getFilePathInDocDir:@"chinaArea.plist"];
        BOOL isOK = [respondDic writeToFile:localPath atomically:YES];
        if (isOK)
        {
            NSLog(@"保存为plist文件成功");
        }
        else
        {
            NSLog(@"保存为plist文件失败");
        }
        return;
    }
    
    [InterfaceManager getAllArea:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed)
        {
            NSLog(@"获取地区信息成功");
            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
            NSError *error = nil;
            //NSLog(@"area dic:%@", dataDic);
            self.country = [[CountryModel alloc] initWithDictionary:dataDic error:&error];
            if (error != nil)
            {
                NSLog(@"json解析失败:%@", error);
                return;
            }
            else
            {
                //NSArray *arrArea = country.provinces;
                ProvinceModel *province = [self.country.provinces objectAtIndex:7];
                NSLog(@"province name:%@, city count:%d", province.name, province.cities.count);
                // 写文件到doc目录下
                NSString *localPath = [DocHelper getFilePathInDocDir:kAreaData];
                NSFileManager *fileHandler = [NSFileManager defaultManager];
                if ([fileHandler fileExistsAtPath:localPath] == NO)
                {
                    //BOOL isOK = [arrArea writeToFile:localPath atomically:YES];
                    NSString *strArea = [dataDic JSONString];
                    //NSLog(@"\n~~~~~~~~~~~~~~~~~~~~~\n%@\n~~~~~~~~~~~~~~~~\n", strArea);
                    BOOL isOK = [strArea writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    if (isOK == NO)
                    {
                        NSLog(@"保存地区数据到本地doc失败");
                        [fileHandler removeItemAtPath:localPath error:nil];
                    }
                    else
                    {
                        NSLog(@"保存地区数据到本地doc成功~!@");
                    }
                }
            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"获取地区信息失败"];
        }
    }];
}

// 测试
- (void)testForAddAddress
{
    AddressItemModel *addressData = [[AddressItemModel alloc] init];
    addressData.name = @"夏志勇";
    addressData.area_id = @"425";
    addressData.addr = @"广东广州市东山区123号";
    addressData.zipcode = @"200082";
    addressData.telephone = @"110";
    addressData.mobile = @"18507103285";
    addressData.is_default = @"1";
    
    [InterfaceManager addAddress:addressData completion:^(BOOL isSucceed, NSString *message, id data) {
        if (isSucceed)
        {
            NSLog(@"添加收货地址成功");
//            NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
//            NSError *error = nil;
//            OrderInfoModel *orderList = [[OrderInfoModel alloc] initWithDictionary:dataDic error:&error];
//            if (error != nil)
//            {
//                NSLog(@"json解析失败:%@", error);
//                return;
//            }
//            else
//            {
//                NSLog(@"order count:%d", orderList.list.count);
//
//            }
        }
        else
        {
            NSLog(@"%@", message);
            [self toast:@"添加地址失败"];
        }
    }];
}

// 编辑 or 添加 收货地址
- (void)editOrAddAction
{
    BOOL isOK = [self checkAddressContent];
    if (isOK == NO)
    {
        return;
    }
    
    [self startLoading:kLoading];
    
    if (_isAdd == YES)  // 添加
    {
        // 发请求
        AddressItemModel *addressData = [[AddressItemModel alloc] init];
        addressData.name = self.txtfieldName.text;
        addressData.area_id = self.strAreaId;  // 传区域id
        addressData.addr = self.txtfieldAddr.text;
        addressData.zipcode = self.txtfieldZipcode.text;
        addressData.telephone = self.txtfieldTel.text;
        addressData.mobile = self.txtfieldMobile.text;
        addressData.is_default = @"1";  // 设置为默认地址
        addressData.addr_id = nil;
        
        [InterfaceManager addAddress:addressData completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed)
            {
                NSLog(@"添加收货地址成功");
                [self toast:@"添加收货地址成功"];
                
                // 返回新增的地址信息
                NSDictionary *dataDic = [(NSDictionary *)data objectForKey:@"data"];    // 取data字段对应的值,为dic
                NSDictionary *receiverDic = [dataDic objectForKey:@"receiver"];
                NSError *error = nil;
                AddressModel *addrNew = [[AddressModel alloc] initWithDictionary:receiverDic error:&error];
                if (error != nil)
                {
                    NSLog(@"json解析失败:%@", error);
                    return;
                }
                NSLog(@"addressId:%@", addrNew.addr_id);
                // 刷新提交订单界面的地址数据显示
                [[NSNotificationCenter defaultCenter] postNotificationName:kShowUserNewAddress object:self userInfo:receiverDic];
                // 刷新地址列表界面的地址数据显示
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAddressList object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"%@", message);
                [self toast:@"添加收货地址失败"];
            }
        }];
    }
    else                // 编辑
    {
        // 发请求
        AddressItemModel *addressData = [[AddressItemModel alloc] init];
        addressData.name = self.txtfieldName.text;
        addressData.area_id = self.strAreaId;  // 传区域id
        addressData.addr = self.txtfieldAddr.text;
        addressData.zipcode = self.txtfieldZipcode.text;
        addressData.telephone = self.txtfieldTel.text;
        addressData.mobile = self.txtfieldMobile.text;
        addressData.is_default = self.curAddrInfo.is_default;   // 是否为默认地址的状态不变
        addressData.addr_id = self.curAddrInfo.addr_id;         // 当前地址的id不变
        
        [InterfaceManager addAddress:addressData completion:^(BOOL isSucceed, NSString *message, id data) {
            [self stopLoading];
            if (isSucceed)
            {
                NSLog(@"编辑收货地址成功");
                [self toast:@"编辑收货地址成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshAddressList object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"%@", message);
                [self toast:@"编辑收货地址失败"];
            }
        }];
    }
}

// 选择地区
- (IBAction)selectRegion:(id)sender;
{
    [self hideKeyboard];
    
    self.viewPick.frame = CGRectMake(0, self.view.frame.size.height-206, 320, 206);
    [self.view addSubview:self.viewPick];
}

// 地区选择的取消与确定
- (IBAction)pickerSelectAction:(id)sender
{
    UIBarButtonItem *barBtn = (UIBarButtonItem *)sender;
    int tag = barBtn.tag;
    if (tag == 0)
    {
        NSLog(@"取消");
    }
    else if (tag == 1)
    {
        NSLog(@"确定");
        // 取值
        int provinceIndex = [self.pickerview selectedRowInComponent:0];
        int cityIndex = [self.pickerview selectedRowInComponent:1];
        int areaIndex = [self.pickerview selectedRowInComponent:2];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex];
        if (province.cities != nil && province.cities.count > 0)
        {
            CityModel *city = [province.cities objectAtIndex:cityIndex];
            if (city.districts != nil && city.districts.count > 0)
            {
                AreaModel *area = [city.districts objectAtIndex:areaIndex];
                self.strArea = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
                self.strAreaId = [NSString stringWithString:area.id];
            }
            else
            {
                self.strArea = [NSString stringWithFormat:@"%@ %@", province.name, city.name];
                self.strAreaId = [NSString stringWithString:city.id];
            }
        }
        else
        {
            self.strArea = [NSString stringWithString:province.name];
            self.strAreaId = [NSString stringWithString:province.id];
        }
        self.txtfieldRegion.text = self.strArea;
        NSLog(@"areaID:%@", self.strAreaId);
    }

    [self.viewPick removeFromSuperview];
    [self.pickerview selectRow:0 inComponent:0 animated:NO];
    [self.pickerview selectRow:0 inComponent:1 animated:NO];
    [self.pickerview selectRow:0 inComponent:2 animated:NO];
    [self.pickerview reloadAllComponents];
}

// 隐藏键盘
- (void)hideKeyboard
{
    [_txtfieldName resignFirstResponder];
    [_txtfieldMobile resignFirstResponder];
    [_txtfieldTel resignFirstResponder];
    [_txtfieldZipcode resignFirstResponder];
    [_txtfieldRegion resignFirstResponder];
    [_txtfieldAddr resignFirstResponder];
}


#pragma mark - Private

- (BOOL)checkAddressContent
{
    [self hideKeyboard];
    
    // 内容合法性校验
    if ([TextVerifyHelper checkContent:_txtfieldName.text] == NO)
    {
        [self toast:@"请输入收货人姓名"];
        return NO;
    }
    // 手机与座机,必填一项
    if ([TextVerifyHelper checkContent:_txtfieldMobile.text] == NO && [TextVerifyHelper checkContent:_txtfieldTel.text] == NO)
    {
        [self toast:@"请输入联系电话"];
        return NO;
    }
    // 若填了手机,则需检测手机号的合法性
    if ([TextVerifyHelper checkContent:_txtfieldMobile.text] == YES)
    {
        if ([_txtfieldMobile.text checkMobileNum] == NO)
        {
            [self toast:@"请输入正确手机号"];
            return NO;
        }
    }
    // 判断座机号的合法性
    
    if ([TextVerifyHelper checkContent:_txtfieldZipcode.text] == NO)
    {
        [self toast:@"请输入邮编"];
        return NO;
    }
    // 判断邮编的合法性
    if ([_txtfieldZipcode.text length] != 6)
    {
        [self toast:@"请输入正确邮编"];
        return NO;
    }
    if ([TextVerifyHelper checkContent:_txtfieldRegion.text] == NO)
    {
        [self toast:@"请选择所在地区"];
        return NO;
    }
    if ([TextVerifyHelper checkContent:_txtfieldAddr.text] == NO)
    {
        [self toast:@"请输入详细地址"];
        return NO;
    }
    
    return YES;
    
//    if (_isAdd)
//    {
//        [self toast:@"添加地址成功"];
//    } else
//    {
//        [self toast:@"添加修改成功"];
//    }
    
    //[self saveData];
    //[self.navigationController popViewControllerAnimated:YES];
}

//- (void)saveData
//{
//    _curAddrInfo.name = _txtfieldName.text;
//    _curAddrInfo.tel = _txtfieldTel.text;
//    _curAddrInfo.zipcode = _txtfieldZipcode.text;
//    _curAddrInfo.region = _txtfieldRegion.text;
//    _curAddrInfo.addr = _txtfieldAddr.text;
//    
//    
//    NSMutableArray *saveArr = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserAddrList] mutableCopy];
//    
//    if (_isAdd) {
//        _curAddrInfo.addrId = [NSNumber numberWithInt:saveArr.count];
//        _curAddrInfo.isDefault = [NSNumber numberWithBool:NO];
//    }
//    
//    [saveArr replaceObjectAtIndex:_editIndex withObject:[_curAddrInfo toDictionary]];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:saveArr forKey:kUserAddrList];
//}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField == _txtfieldName)
    {
        if (range.location >= NameMaxLength) {
            int maxLength = NameMaxLength;
            [self toast:[NSString stringWithFormat:@"姓名长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    if (textField == _txtfieldMobile)
    {
        if (range.location >= MobileMaxLength) {
            int maxLength = MobileMaxLength;
            [self toast:[NSString stringWithFormat:@"手机号长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    else if (textField == _txtfieldTel)
    {
        if (range.location >= TelMaxLength) {
            int maxLength = TelMaxLength;
            [self toast:[NSString stringWithFormat:@"座机号长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    else if (textField == _txtfieldZipcode)
    {
        if (range.location >= ZipcodeMaxLength) {
            int maxLength = ZipcodeMaxLength;
            [self toast:[NSString stringWithFormat:@"邮编长度不得超过%d位", maxLength]];
            return NO;
        }
    }
//    else if (textField == _txtfieldRegion)
//    {
//        if (range.location >= TelMaxLength) {
//            int maxLength = TelMaxLength;
//            [self toast:[NSString stringWithFormat:@"区域长度不得超过%d位", maxLength]];
//            return NO;
//        }
//    }
    else if (textField == _txtfieldAddr)
    {
        if (range.location >= AddressMaxLengt) {
            int maxLength = AddressMaxLengt;
            [self toast:[NSString stringWithFormat:@"地址长度不得超过%d位", maxLength]];
            return NO;
        }
    }
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // KeyBoardTopBar的实例对象调用显示键盘方法
    [keyboardbar showBar:textField];
}

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([_txtfieldName isFirstResponder])
    {
        [self.scrollContent scrollRectToVisible:CGRectMake(0, _txtfieldName.frame.origin.y, 320, 60) animated:YES];
    }
    else if ([_txtfieldMobile isFirstResponder])
    {
        [self.scrollContent scrollRectToVisible:CGRectMake(0, _txtfieldMobile.frame.origin.y, 320, 60) animated:YES];
    }
    else if ([_txtfieldTel isFirstResponder])
    {
        [self.scrollContent scrollRectToVisible:CGRectMake(0, _txtfieldTel.frame.origin.y, 320, 60) animated:YES];
    }
    else if ([_txtfieldZipcode isFirstResponder])
    {
        [self.scrollContent scrollRectToVisible:CGRectMake(0, _txtfieldZipcode.frame.origin.y, 320, 60) animated:YES];
    }
    else if ([_txtfieldAddr isFirstResponder])
    {
        [self.scrollContent scrollRectToVisible:CGRectMake(0, _txtfieldAddr.frame.origin.y, 320, 60) animated:YES];
    }
    else {
        //
    }
    return  YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_txtfieldName isFirstResponder])
    {
        [_txtfieldMobile becomeFirstResponder];
    }
    else if ([_txtfieldMobile isFirstResponder])
    {
        [_txtfieldTel becomeFirstResponder];
    }
    else if ([_txtfieldTel isFirstResponder])
    {
        [_txtfieldZipcode becomeFirstResponder];
    }
//    else if ([_txtfieldZipcode isFirstResponder])
//    {
//        [_txtfieldRegion becomeFirstResponder];
//    }
    else if ([_txtfieldZipcode isFirstResponder])
    {
        [_txtfieldAddr becomeFirstResponder];
    }
    else if ([_txtfieldAddr isFirstResponder])
    {
        [_txtfieldAddr becomeFirstResponder];
        //[self hideKeyboard];
        LogTrace(@" {Button Click} : keyboard return");
        [self performSelector:@selector(checkAddressContent)];
    }
    else {
        //
    }
    return  YES;
}
*/


#pragma mark - UITouchEvent

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillShow");
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height; // 获取键盘高度
    //NSLog(@"<keyboardHeight:%f>",keyboardHeight);
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;   // 键盘动画时间
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat scrollHeight = kScreenHeight - 64 - keyboardHeight;
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect myRect = _viewRect;
        myRect.size.height = scrollHeight;
        self.scrollContent.frame = myRect;
    } completion:^(BOOL finished) {
        //
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    //NSLog(@"keyboardWillHide");
    
    // 自定义动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = CGRectMake(0, 0, 320, 271);
        self.scrollContent.frame = rect;
    } completion:^(BOOL finished) {
        //
    }];
    
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 38;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //return 107;
    if (component == 0)
    {
        return 80;
    }
    else if (component == 1)
    {
        return 140;
    }
    else if (component == 2)
    {
        return 90;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.country.provinces.count;
    }
    else if (component == 1)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex];
        if (province.cities != nil && province.cities.count > 0)
        {
            return province.cities.count;
        }
        else
        {
            return 0;
        }
    }
    else if (component == 2)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex]; // 获取指定省
        if (province.cities != nil && province.cities.count > 0)
        {
            int cityIndex = [pickerView selectedRowInComponent:1];
            CityModel *city = [province.cities objectAtIndex:cityIndex];
            if (city.districts != nil && city.districts.count > 0)
            {
                return city.districts.count;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //return @"地区";
    if (component == 0)
    {
        ProvinceModel *province = [self.country.provinces objectAtIndex:row];
        return province.name;
    }
    else if (component == 1)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex];
        if (province.cities != nil && province.cities.count > 0)
        {
            CityModel *city = [province.cities objectAtIndex:row];
            return city.name;
        }
        else
        {
            return nil;
        }
    }
    else if (component == 2)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex]; // 获取指定省
        if (province.cities != nil && province.cities.count > 0)
        {
            int cityIndex = [pickerView selectedRowInComponent:1];
            CityModel *city = [province.cities objectAtIndex:cityIndex];
            if (city.districts != nil && city.districts.count > 0)
            {
                AreaModel *area = [city.districts objectAtIndex:row];
                return area.name;
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [pickerView selectRow:row inComponent:0 animated:YES];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex];
        if (province.cities != nil && province.cities.count > 0)
        {
            [pickerView selectRow:row inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
        else
        {
            //
        }
    }
    else if (component == 2)
    {
        int provinceIndex = [pickerView selectedRowInComponent:0];
        ProvinceModel *province = [self.country.provinces objectAtIndex:provinceIndex]; // 获取指定省
        if (province.cities != nil && province.cities.count > 0)
        {
            int cityIndex = [pickerView selectedRowInComponent:1];
            CityModel *city = [province.cities objectAtIndex:cityIndex];
            if (city.districts != nil && city.districts.count > 0)
            {
                [pickerView selectRow:row inComponent:2 animated:YES];
                [pickerView reloadComponent:2];
            }
            else
            {
                //
            }
        }
        else
        {
            //
        }
    }
    else
    {
        //
    }
}



@end
