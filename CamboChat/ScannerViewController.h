//
//  ScannerViewController.h
//  SwiftPages
//
//  Created by Yoman on 9/8/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YomanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "SingleTonManager.h"

@interface ScannerViewController : YomanViewController{
    AVCaptureSession *torchSession;
}
@property(nonatomic,retain)AVCaptureSession *torchSession;
@end
