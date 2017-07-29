//
//  VisionViewController.m
//  VisionLearn
//
//  Created by dasen on 2017/6/16.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "VisionViewController.h"
#import "DSFaceViewController.h"
#import "DSVisionTool.h"
#import "CameraCaptureController.h"

@interface VisionViewController ()
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation VisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [UIView new];
    self.dataArray = @[@"人脸识别",@"特征识别",@"文字识别",@"实时检测Face",@"实时动态添加"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *content = self.dataArray[indexPath.row];
    
    if ([content isEqualToString:@"人脸识别"]) {
        DSFaceViewController *vc = [[DSFaceViewController alloc]initWithDetectionType:DSDetectionTypeFace];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([content isEqualToString:@"特征识别"]) {
        DSFaceViewController *vc = [[DSFaceViewController alloc]initWithDetectionType:DSDetectionTypeLandmark];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([content isEqualToString:@"文字识别"]) {
        DSFaceViewController *vc = [[DSFaceViewController alloc]initWithDetectionType:DSDetectionTypeTextRectangles];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([content isEqualToString:@"实时检测Face"]) {
        CameraCaptureController *vc = [[CameraCaptureController alloc]initWithDetectionType:DSDetectionTypeFaceRectangles];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([content isEqualToString:@"实时动态添加"]) {
        CameraCaptureController *vc = [[CameraCaptureController alloc]initWithDetectionType:DSDetectionTypeFaceHat];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

@end
