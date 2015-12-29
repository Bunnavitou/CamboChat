//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtils : NSObject

////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showWaitingSplash;
+ (void)closeWaitingSplash;


////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;





@end
