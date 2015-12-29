//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface SysUtils : NSObject

//=========== Check Null ================//
+ (BOOL)isNull:(id) obj;
+ (NSString *)nullToVoid:(NSString *)aSource;

//========== Messsage Alert =============//
+ (void)showMessage:(NSString *)aMsg;
+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner;
+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner tag:(NSInteger)aTag;

//========== Covert Method ==============//
+ (NSString *)integerToString:(NSInteger) value;
+ (NSString *)doubleToString:(double) value;
+ (NSString *)doubleToIntString:(double) value;
+ (NSString *)boolToString:(BOOL) value;

//========== Get Iphone Info =============//
+ (NSString *)getCurrentIPAddress;
+ (NSString *)getCurrentMACAddress;
+ (NSString	*)getCurrentUDID;
+ (NSString *)getDeviceModel;
+ (NSInteger)getOSVersion;
+ (NetworkStatus)getCurrentNetworkStatus;

//========== Check Application ============//
+ (BOOL)applicationExecute:(NSString *)urlScheme;
+ (BOOL)canExecuteApplication:(NSString *)urlScheme;

//========== Check Application ============//
+ (BOOL)isPad;
+ (NSString *)md5String:(NSString*)userID currentsTime:(NSString*)currentTime;
+ (NSString *)tempMd5String:(NSString*)testString;
+ (NSData *)md5tem:(NSString *)mD5;

@end





