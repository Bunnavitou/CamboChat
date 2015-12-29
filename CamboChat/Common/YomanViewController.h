//
//  YomanViewController.h
//  JobTesting
//
//  Created by Yoman on 6/30/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleTonManager.h"
#import "SercurityConnection.h"
#import "WebViewStyleViewController.h"
#import "JSON.h"
#import "Constants.h"
#import "URLUtils.h"
#import "WaitingSplashView.h"



@interface YomanViewController : UIViewController<SecurityConnectionDelegate>{
    
        WaitingSplashView* _waitingSplash;
}
@property (nonatomic, retain)WaitingSplashView* waitingSplash;


-(void)yoSetTittle:(NSString *)strTittle;


- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize;
- (CGFloat)measureTextWidth:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize;

- (void)sendTransaction:(NSDictionary *)requestDictionary;
- (void)returnTransaction:(NSDictionary *)responseDictionary success:(BOOL)success;


@end
