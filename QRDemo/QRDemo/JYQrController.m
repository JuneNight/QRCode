//
//  JYQrController.m
//  QRDemo
//
//  Created by 张涛 on 17/5/23.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JYQrController.h"
#import <AVFoundation/AVFoundation.h>

@interface JYQrController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (nonatomic, retain) CAShapeLayer *mask;
@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previweLayer;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visEffView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLine;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@end

@implementation JYQrController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initAVCapture];
    
   [self initAnimation];
    self.mask = [CAShapeLayer layer];
    self.mask.fillRule = kCAFillRuleEvenOdd;
    self.visEffView.layer.mask = self.mask;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //layout preview layer
    self.previweLayer.bounds = self.preView.bounds;
    self.previweLayer.position = CGPointMake(CGRectGetMidX(self.preView.bounds), CGRectGetMidY(self.preView.bounds));
    //configure blur view mask layer
    self.mask.frame = self.visEffView.bounds;
    UIBezierPath *outRectangle = [UIBezierPath bezierPathWithRect:self.visEffView.bounds];
    UIBezierPath *inRectangle = [UIBezierPath bezierPathWithRect:self.contentBack.frame];
    [outRectangle appendPath:inRectangle];
    outRectangle.usesEvenOddFillRule = YES;
    self.mask.path = outRectangle.CGPath;
}

- (void)initAVCapture{
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (deviceInput) {
        [self.session addInput:deviceInput];
    }else{
        NSLog(@"%@",error);
        return;
    }
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:outPut];
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.previweLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.preView.layer addSublayer:self.previweLayer];
    [self.session startRunning];
}

- (void)initAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue = [NSNumber numberWithFloat:CGRectGetHeight(self.contentBack.frame)];
    animation.duration = 2.0;
    animation.repeatCount = MAXFLOAT;
    [self.lineV.layer addAnimation:animation forKey:@"move-layer"];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
        NSURL *url = [NSURL URLWithString:metadata.stringValue];
        if (url && url.host) {
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:^(BOOL success) {
                
            }];
        }
        NSLog(@"%@",metadata.stringValue);
    }
}
@end
