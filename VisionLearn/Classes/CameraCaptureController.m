//
//  CameraCaptureController.m
//  VisionLearn
//
//  Created by dasen on 2017/6/17.
//  Copyright © 2017年 Dasen. All rights reserved.
//
#import "DSVisionTool.h"
#import "CameraCaptureController.h"
typedef void(^detectFaceRequestHandler)(VNRequest *request, NSError * _Nullable error);

@interface CameraCaptureController () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong)NSMutableArray *layers;
@property (nonatomic, strong)NSMutableArray *hats;

@property (nonatomic, assign)DSDetectionType detectionType;
@property (nonatomic, copy) detectFaceRequestHandler faceHandler;
@end

@implementation CameraCaptureController

- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type{
    if (self = [super init]) {
       _detectionType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"横屏实时检测";
    
    // 请求授权
    [self getAuthorization];
}

/// 初始化相关内容
- (void)initCapture
{
    [self addSession];
    [_captureSession beginConfiguration];
    
    [self addVideo];
    [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];
}

/// 获取输出
- (void)captureOutput:(AVCaptureFileOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef BufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    VNDetectFaceRectanglesRequest *detectFaceRequest = [[VNDetectFaceRectanglesRequest alloc ]init];
    VNImageRequestHandler *detectFaceRequestHandler = [[VNImageRequestHandler alloc]initWithCVPixelBuffer:BufferRef options:@{}];
    
    [detectFaceRequestHandler performRequests:@[detectFaceRequest] error:nil];
    NSArray *results = detectFaceRequest.results;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.detectionType == DSDetectionTypeFaceRectangles) {
            //矩形
            for (CALayer *layer in self.layers) {
                [layer removeFromSuperlayer];
            }
            
        }else if (self.detectionType == DSDetectionTypeFaceHat)
        {
            // 帽子
            for (UIImageView *imageV in self.hats) {
                [imageV removeFromSuperview];
            }
        }
        
        [self.layers removeAllObjects];
        [self.hats removeAllObjects];
        
    
    for (VNFaceObservation *observation  in results) {
        CGRect oldRect = observation.boundingBox;
        CGFloat w = oldRect.size.width * self.view.bounds.size.width;
        CGFloat h = oldRect.size.height * self.view.bounds.size.height;
        CGFloat x = oldRect.origin.x * self.view.bounds.size.width;
        CGFloat y = self.view.bounds.size.height - (oldRect.origin.y * self.view.bounds.size.height) - h;
        
        // 添加矩形
        CGRect rect = CGRectMake(x, y, w, h);
        CALayer *testLayer = [[CALayer alloc]init];
        testLayer.borderWidth = 2;
        testLayer.cornerRadius = 3;
        testLayer.borderColor = [UIColor redColor].CGColor;
        testLayer.frame = CGRectMake(x, y, w, h);
        
        [self.layers addObject:testLayer];
        
        // 添加帽子
        CGFloat hatWidth = w;
        CGFloat hatHeight = h;
        CGFloat hatX = rect.origin.x - hatWidth / 4 + 3;
        CGFloat hatY = rect.origin.y -  hatHeight;
        CGRect hatRect = CGRectMake(hatX, hatY, hatWidth, hatHeight);
        
        UIImageView *hatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hat"]];
        hatImage.frame = hatRect;
        [self.hats addObject:hatImage];
    }
        
        if (self.detectionType == DSDetectionTypeFaceRectangles) {
            //矩形
            for (CALayer *layer in self.layers) {
                [self.view.layer addSublayer:layer];
            }
            
        }else if (self.detectionType == DSDetectionTypeFaceHat)
        {
            // 帽子
            for (UIImageView *imageV in self.hats) {
                [self.view addSubview:imageV];
            }
        } 
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
     _captureVideoPreviewLayer.frame = self.view.bounds;
}
#pragma mark - 不常用

/// 添加预览视图
- (void)addPreviewLayer
{
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = self.view.bounds;
    
    //有时候需要拍摄完整屏幕大小的时候可以修改这个
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.connection.videoOrientation = 3;
    
    // 显示在视图表面的图层
    CALayer *layer = self.view.layer;
    layer.masksToBounds = true;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
}

/// 添加video
- (void)addVideo
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addDataOutput];
}

/// 添加videoinput
- (void)addVideoInput
{
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:NULL];
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
}

/// 添加数据输出
- (void)addDataOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_dataOutput setSampleBufferDelegate:self queue:dispatch_queue_create("CameraCaptureSampleBufferDelegateQueue", NULL)];
    
    if ([_captureSession canAddOutput:_dataOutput]) {
        [_captureSession addOutput:_dataOutput];
        AVCaptureConnection *captureConnection = [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([captureConnection isVideoOrientationSupported]) {
            [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        // 设置输出图片方向
        captureConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
}

- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    //设置视频分辨率
    //注意,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小,
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
}

/// 获取设备
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (NSMutableArray *)layers
{
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (NSMutableArray *)hats
{
    if (!_hats) {
        _hats = @[].mutableCopy;
    }
    return _hats;
}

- (void)getAuthorization
{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoStatus)
    {
        case AVAuthorizationStatusAuthorized:
        case AVAuthorizationStatusNotDetermined:
            [self initCapture];
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self showMsgWithTitle:@"相机未授权" andContent:@"请打开设置-->隐私-->相机-->快射-->开启权限"];
            break;
        default:
            break;
    }
}

- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil
                                          cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"去开启"];
    [alert show];
    alert.delegate = self;
}

/// 强制横屏
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationLandscapeRight;//横屏
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}

-(void)pop
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
