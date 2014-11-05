//
//  ScanQRViewController.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanQRViewController ()

@property (nonatomic, strong) ZXCapture *capture;

@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (nonatomic, weak) IBOutlet UILabel *decodedLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imgviewScanRect;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewScanBar;
@property (nonatomic, strong) NSTimer *timerScan;
@property BOOL moveDown;

@end


@implementation ScanQRViewController

static const CGFloat kTopBar = 10;
static const CGFloat kButtomBar = 236;

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
    
    self.navigationItem.title = @"二维码扫描";
    //[self.navController showBackButtonWith:self];
    [self.navController showBackButtonWith:self andAction:@selector(backAction)];
    
    // 导航右边照片选择按钮
    UIButton *btnPic = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPic.frame = CGRectMake(0, 6, 42, 32);
    [btnPic setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
//    [btnBack setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [btnPic addTarget:self action:@selector(selectPicture) forControlEvents:UIControlEventTouchUpInside];
//    settingBack.imageEdgeInsets = UIEdgeInsetsMake(-1, -30, 0, 0);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnPic];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    // 设置扫描对象
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    // 增加扫描动画
    self.moveDown = YES;
    self.timerScan = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(moveScanBar) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timerScan forMode:NSDefaultRunLoopMode];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    self.capture.scanRect = self.scanRectView.frame;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    // pop或dismiss前需要remove
    [self.capture.layer removeFromSuperlayer];
    [self.capture stop];
    
    // 关闭定时器
    [self stopScanAndMove];
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

// 选取相片
- (void)selectPicture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        [imagePickerController setAllowsEditing:YES];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }else {
            [self presentViewController:imagePickerController animated:YES completion:^{
                //
            }];
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"打开相册失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

// 扫描图片
- (void)decodePhotoFromDevice
{
    
//    Decoder *d = [[Decoder alloc] init];
//    d.readers = readers;
//    d.delegate = self;
//    //CGRect cropRect = self.overlayView.frame;
//    CGRect cropRect;
//    cropRect.size = img_Photo_.size;
//    cropRect.origin.x = 0.0;
//    cropRect.origin.y = 0.0;
//    decoding = [d decodeImage:img_Photo_ cropRect:cropRect] == YES ? NO : YES;  // point!!!
//    scanPhoto_ = YES;
//    [d release];
    
    // (CVImageBufferRef)BufferRef
    //CGImageRef videoFrameImage = [ZXCGImageLuminanceSource createImageFromBuffer:BufferRef];
    //CGImageRef rotatedImage = [self rotateImage:videoFrameImage degrees:0.0f];
    
    CGImageRef videoFrameImage = self.imgPic.CGImage;
    //NSMakeCollectable(videoFrameImage);
    
    // Decoding:
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:videoFrameImage];
    //NSMakeCollectable(videoFrameImage);
    
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError* error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    
    if (result) {
        
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        //NSString *contents = result.text;
        
        NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
        
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // The barcode format, such as a QR code or UPC-A
        //ZXBarcodeFormat format = result.barcodeFormat;
        
    }else {
        
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        
        
    }
    
}


#pragma mark - ScanAnimation

// 移动扫描栏
- (void)moveScanBar {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    if (_moveDown == YES) {
        
        CGPoint myPoint = _imgviewScanBar.center;
        myPoint.y = myPoint.y + 6;
        _imgviewScanBar.center = myPoint;
        
        if (myPoint.y >= kButtomBar) {
            _moveDown = NO;
        }
        
    }else {
        
        CGPoint myPoint = _imgviewScanBar.center;
        myPoint.y = myPoint.y - 6;
        _imgviewScanBar.center = myPoint;
        
        if (myPoint.y <= kTopBar) {
            _moveDown = YES;
        }
        
    }
    [UIView commitAnimations];
    
}

// 停止扫描与移动
- (void)stopScanAndMove
{
    if ([_timerScan isValid])
    {
        [_timerScan invalidate];
    }
    self.timerScan = nil;
    self.moveDown = YES;
}

// 重新开始扫描并移动
- (void)restartScanAndMove
{
//    if ([_timerScan isValid] == NO)
//    {
//        [_timerScan fire];
//    }
    
    if ([_timerScan isValid])
    {
        [_timerScan invalidate];
        self.timerScan = nil;
    }
    self.moveDown = YES;
    self.timerScan = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(moveScanBar) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timerScan forMode:NSDefaultRunLoopMode];
}


#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    CFShow((__bridge CFTypeRef)(info));
    if (_imgPic) {
        self.imgPic = nil;
    }
    self.imgPic = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(decodePhotoFromDevice) userInfo:nil repeats:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
