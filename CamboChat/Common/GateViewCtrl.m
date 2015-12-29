//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import "GateViewCtrl.h"
#import "SysUtils.h"
#import "Constants.h"
#import "SingleTonManager.h"
#import "AppUtils.h"


@implementation GateViewCtrl

@synthesize waitingSplash = _waitingSplash;

static const NSInteger kTagWaitingSplashView					= 5001;

#pragma mark - LifeCycle Method -
- (void)viewDidLoad                 {
    [super viewDidLoad];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWaitingSplash:)  name:kShowWaitingViewNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWaitingSplash:) name:kCloaseWaitingViewNotification object:nil];

}
- (void)didReceiveMemoryWarning     {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload               {
    [super viewDidUnload];
}

#pragma mark - Notificaiton Method -
- (void)showWaitingSplash:(NSNotification *)note    {
    if ([SysUtils isNull:_waitingSplash] == YES) {
        _waitingSplash		= [[WaitingSplashView alloc] init];
        _waitingSplash.tag	= kTagWaitingSplashView;
    }
    
    [self.view addSubview:_waitingSplash];
    [_waitingSplash show];
    
    self.view.userInteractionEnabled = NO;
    
}
- (void)closeWaitingSplash:(NSNotification *)note   {
    if ([SysUtils isNull:_waitingSplash] == YES)
        return;
    
    [_waitingSplash close];
    
    UIView *viewCurrentSplash = [self.view viewWithTag:kTagWaitingSplashView];
    if ([SysUtils isNull:viewCurrentSplash] == NO)
        [viewCurrentSplash removeFromSuperview];
    
    self.view.userInteractionEnabled = YES;
}


@end
