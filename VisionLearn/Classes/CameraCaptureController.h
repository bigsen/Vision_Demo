//
//  CameraCaptureController.h
//  VisionLearn
//
//  Created by dasen on 2017/6/17.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface CameraCaptureController : UIViewController
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoDataOutput *_dataOutput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
}

- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type;

@end
