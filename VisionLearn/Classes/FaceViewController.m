//
//  FaceDetectionViewController.m
//  VisionLearn
//
//  Created by dasen on 2017/6/16.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "FaceViewController.h"
#import <CoreMedia/CoreMedia.h>

@interface FaceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerVc;
@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, assign) DetectionType detectionType;
@property (nonatomic, copy) detectRequestHandler faceHandler;

@end

@implementation FaceViewController

- (instancetype)initWithDetectionType:(DetectionType)type
{
    if (self = [super init]) {
        _detectionType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    
    [self.view addSubview:self.showImageView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:self.pickerVc animated:NO completion:nil];
    });
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [self.pickerVc dismissViewControllerAnimated:NO completion:nil];
    [self detectFace:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.pickerVc dismissViewControllerAnimated:YES completion:nil];
}

/// 进行识别
- (void)detectFace:(UIImage *)image{
    
    UIImage *localImage = [image scaleImage:SCREEN_WIDTH];
    [self.showImageView setImage:localImage];
    self.showImageView.size = localImage.size;
    VisionTool *tool = [VisionTool new];
    
    [tool detectionImageWithType:self.detectionType image:localImage requestHandler:^(UIView * _Nullable image) {
        switch (self.detectionType) {
            case DetectTextRectangles:
            case DetectionTypeFace:
                [self.showImageView addSubview:image];
                break;
            case DetectionTypeLandmark:
                self.showImageView.image = (UIImage *)image;
            default:
                break;
        }
    }];
}

#pragma mark 懒加载控件
- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.width)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = [UIColor orangeColor];
    }
    return _showImageView;
}

- (UIImagePickerController *)pickerVc
{
    if (!_pickerVc) {
        _pickerVc = [[UIImagePickerController alloc]init];
        _pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerVc.delegate = self;
    }
    return _pickerVc;
}
@end


