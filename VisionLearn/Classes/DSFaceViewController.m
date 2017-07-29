//
//  DSFaceViewController.m
//  VisionLearn
//
//  Created by dasen on 2017/7/6.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "DSFaceViewController.h"
#import "DSViewTool.h"
#import "DSDetectData.h"
@interface DSFaceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) DSDetectionType detectionType;

@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIImagePickerController *pickerVc;
@end

@implementation DSFaceViewController



- (instancetype _Nullable )initWithDetectionType:(DSDetectionType)type
{
    if (self = [super init]) {
        _detectionType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showImageView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)detectFace:(UIImage *)image{
    
    UIImage *localImage = [image scaleImage:SCREEN_WIDTH];
    [self.showImageView setImage:localImage];
    self.showImageView.size = localImage.size;
    
    [DSVisionTool detectImageWithType:self.detectionType image:localImage complete:^(DSDetectData * _Nullable detectData) {
        switch (self.detectionType) {
            case DSDetectionTypeFace:
                for (NSValue *rectValue in detectData.faceAllRect) {
                    [self.showImageView addSubview: [DSViewTool getRectViewWithFrame:rectValue.CGRectValue]];
                }
                break;
            case DSDetectionTypeLandmark:
                
                for (DSDetectFaceData *faceData in detectData.facePoints) {
                  self.showImageView.image = [DSViewTool drawImage:self.showImageView.image observation:faceData.observation pointArray:faceData.allPoints];
                }
                break;
            case DSDetectionTypeTextRectangles:
                for (NSValue *rectValue in detectData.textAllRect) {
                    [self.showImageView addSubview: [DSViewTool getRectViewWithFrame:rectValue.CGRectValue]];
                }
                break;
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
