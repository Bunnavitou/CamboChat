//
//  SercurityConnection.h
//  JobTesting
//
//  Created by Yoman on 6/29/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JSON.h"
enum {
    TRANS_METHOD_GET = 0,
    TRANS_METHOD_POST 
};typedef NSUInteger SecurityMethod;


@class SecurityHandler;


@protocol SecurityConnectionDelegate;




@interface SercurityConnection : UIWebView {
    SecurityHandler*	handler;
}

@property(nonatomic, retain) SecurityHandler *handler;

+ (SercurityConnection *)sharedSecurityConnection;

- (BOOL)willConnect:(NSString *) url query:(NSDictionary *) query method:(NSInteger) method;


@end


@protocol SecurityConnectionDelegate<UIWebViewDelegate,NSURLConnectionDataDelegate>

@optional
-(void)returnResult:(NSString *)returnResult errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage;

@end