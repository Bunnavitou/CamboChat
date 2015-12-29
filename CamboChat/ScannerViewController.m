//
//  ScannerViewController.m
//  SwiftPages
//
//  Created by Yoman on 9/8/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "ScannerViewController.h"

@interface ScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
    
}

@end

@implementation ScannerViewController

@synthesize torchSession;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor magentaColor].CGColor;
    _highlightView.layer.borderWidth = 2;
    _highlightView.layer.shadowOpacity = 2;
    [self.view addSubview:_highlightView];
    

    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = RGB(242, 163, 95);
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
    
    
    UIButton *playFlash = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playFlash.frame = CGRectMake(0, 20.0, 90.0, 40.0);
    [playFlash setTitle:@"Flash ON" forState:UIControlStateNormal];
    playFlash.backgroundColor = RGB(242, 163, 95);
    [playFlash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [playFlash setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted ];
    [playFlash addTarget:self action:@selector(FlashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playFlash];
    
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 20.0, 60.0, 40.0);
    [playButton setTitle:@"Close" forState:UIControlStateNormal];
    playButton.backgroundColor = RGB(242, 163, 95);
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [playButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted ];
    [playButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIView *viewTest = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 20)];
    viewTest.backgroundColor=RGB(242, 163, 95);
    [self.view addSubview:viewTest];
}



- (void)FlashAction:(UIButton*)button{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        if (device.torchMode == AVCaptureTorchModeOff) {
            [button setTitle:@"Flash OFF" forState:UIControlStateNormal];
            
            AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
            
            AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            
            [session beginConfiguration];
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            [session addInput:flashInput];
            [session addOutput:output];
            [device unlockForConfiguration];
            [session commitConfiguration];
            [session startRunning];
            [self setTorchSession:session];
        }
        else
        {
            [button setTitle:@"Flash ON" forState:UIControlStateNormal];
            [torchSession stopRunning];
        }
    }
}
- (void)closeAction:(UIButton*)button{
   
    [self dismissViewControllerAnimated:YES completion:nil];


}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            break;
        }
        else
            _label.text = @"(none)";
    }
    
    _highlightView.frame = highlightViewRect;
}


@end
