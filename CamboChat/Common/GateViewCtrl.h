//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingSplashView.h"


@interface GateViewCtrl : UINavigationController {
    
	WaitingSplashView* _waitingSplash;
    
}
@property (nonatomic, retain)WaitingSplashView* waitingSplash;

@end
