//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import "AppUtils.h"
#import "Constants.h"
#import "SysUtils.h"

@implementation AppUtils

////////////////////////////////////
//////Navigation Bar Left and Right
////////////////////////////////////
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    if ([SysUtils isNull:aNormalImageCode] == YES)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/4, imgNormal.size.height/4)];
    
    [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([SysUtils isNull:aHighlightImageCode] == NO)
        [btnNewLeft setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:btnNewLeft];
    calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
   
    
}
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    if ([SysUtils isNull:aNormalImageCode] == YES)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    UIButton* btnNewRight				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/4, imgNormal.size.height/4)];
    
    [btnNewRight setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([SysUtils isNull:aHighlightImageCode] == NO)
        [btnNewRight setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewRight addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarRight						= [[UIBarButtonItem alloc] initWithCustomView:btnNewRight];
    calleeViewCtrl.navigationItem.rightBarButtonItem	= btnNewBarRight;
    
}

////////////////////////////////////
//////Show and Close WaitingSplash
////////////////////////////////////
+ (void)showWaitingSplash   {
	[[NSNotificationCenter defaultCenter] postNotificationName:kShowWaitingViewNotification object:self userInfo:nil];
}
+ (void)closeWaitingSplash  {
	[[NSNotificationCenter defaultCenter] postNotificationName:kCloaseWaitingViewNotification object:self userInfo:nil];
}



@end
