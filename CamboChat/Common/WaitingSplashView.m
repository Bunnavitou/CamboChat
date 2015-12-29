//
//  WaitingSplashView.m
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WaitingSplashView.h"
#import "SingleTonManager.h"
#import "SysUtils.h"
#import "Constants.h"

@interface WaitingSplashView(){
    BOOL isShowingLandscapeView;
}

@end

@implementation WaitingSplashView

- (void)show {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
    
    CATransition* push	= [CATransition animation];
    push.type			= kCATransitionPush;
    push.subtype		= kCATransitionFromTop;
    
    [self.layer addAnimation:push forKey:kCATransition];
    //======For OrientationNotifications
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChangedAction:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [CATransaction flush];
    [CATransaction commit];
    
    //=======for NetworkActivity
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor magentaColor]];
}

- (void)close {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:0.3f] forKey:kCATransactionAnimationDuration];
    
    CATransition* push	= [CATransition animation];
    push.type			= kCATransitionPush;
    push.subtype		= kCATransitionFromBottom;
    
    [self.layer addAnimation:push forKey:kCATransition];
    
    self.frame = CGRectMake(0.0f, [[UIScreen mainScreen] applicationFrame].size.height+40, 0, 0);
    
    [CATransaction commit];
    
    //=======for NetworkActivity
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
}

- (void)orientationChangedAction:(NSNotification *)notification{
    UIImageView *tempView = (UIImageView *)[self viewWithTag:5001];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.frame = screenRect;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView) {
        tempView.frame  =CGRectMake(screenRect.size.width/4 - 130/4,-screenRect.size.height/2 , 130/2, 130/2);
        
    }else if(UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView){
        tempView.frame=CGRectMake((screenRect.size.width/2) - 130/4,(screenRect.size.height/2)-13.5, 130/2, 130/2);
        
    }
}

#pragma mark -
#pragma mark - LifeCycle Method -
- (void)internalInit {
    if (self == nil)
        return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIImageView* lodingImageView = [[UIImageView alloc] init];
    lodingImageView.frame=CGRectMake((screenRect.size.width/2) - 130/4,(screenRect.size.height/2)-13.5, 130/2, 130/2);
    
    lodingImageView.image        = [UIImage imageNamed:@"load_00.png"];
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130/2, 130/2)];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"loadingM_img1.png"],
                                         [UIImage imageNamed:@"loadingM_img2.png"],
                                         [UIImage imageNamed:@"loadingM_img3.png"],
                                         [UIImage imageNamed:@"loadingM_img4.png"],
                                         [UIImage imageNamed:@"loadingM_img5.png"],
                                         [UIImage imageNamed:@"loadingM_img6.png"],
                                         [UIImage imageNamed:@"loadingM_img7.png"],
                                         [UIImage imageNamed:@"loadingM_img8.png"],
                                         [UIImage imageNamed:@"loadingM_img9.png"],
                                         [UIImage imageNamed:@"loadingM_img10.png"],
                                         nil];

    animatedImageView.animationDuration     = 1.0;
    animatedImageView.animationRepeatCount  = 0;
    [lodingImageView addSubview:animatedImageView];
    lodingImageView.tag                     = 5001;
    
    [self addSubview:lodingImageView];
    [animatedImageView startAnimating];
}
- (id)init {
    self = [super init];

    [self internalInit];
 
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
