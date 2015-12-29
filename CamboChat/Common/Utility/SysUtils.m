//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import "SysUtils.h"
#import "Constants.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import "Reachability.h"
#import "IPAddress.h"

@implementation SysUtils

////=====================================================================================////
#pragma mark - Check Null -
////=====================================================================================////
+ (BOOL)isNull:(id)obj                          {
    if (obj == nil || obj == [NSNull null])
        return YES;
    
    if ([obj isKindOfClass:[NSString class]] == YES) {
        if ([(NSString *)obj isEqualToString:@""] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"<null>"] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"null"] == YES)
            return YES;
    }
    
    return NO;
}
+ (NSString *)nullToVoid:(NSString *)aSource    {
    if ([self isNull:aSource] == YES)
        return @"";
    return aSource;
}

////=====================================================================================////
#pragma mark - Message AlertView -
////=====================================================================================////
+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner tag:(NSInteger)aTag  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:aMsg
                                                   delegate:aOwner
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    alert.tag = aTag;
    
    [alert show];
}

+ (void)showMessageWithOwner:(NSString *)aMsg owner:(id)aOwner                      {
    [self showMessageWithOwner:aMsg owner:aOwner tag:0];
}

+ (void)showMessage:(NSString *)aMsg                                                {
    [self showMessageWithOwner:aMsg owner:nil tag:0];
}

////=====================================================================================////
#pragma mark - Covert Method -
////=====================================================================================////
+ (NSString *)integerToString:(NSInteger)value  {
    return [[NSString alloc] initWithFormat:@"%ld", (long)value];
}

+ (NSString *)doubleToString:(double)value      {
    return [[NSString alloc] initWithFormat:@"%f", value];
}

+ (NSString *)doubleToIntString:(double)value   {
    return [self integerToString:[[NSNumber numberWithDouble:value]intValue]];
}

+ (NSString *)boolToString:(BOOL)value          {
    return (value == YES ? @"YES" : @"NO");
}

+ (NSString *)getCurrentIPAddress               {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    NSString *ipAddress = [NSString stringWithFormat:@"%s", ip_names[1]];
    FreeAddresses();
    
    return ipAddress;
}

+ (NSString *)getCurrentMACAddress              {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    NSString *macAddress = [NSString stringWithFormat:@"%s", hw_addrs[1]];
    FreeAddresses();
    
    return macAddress;
}

+ (NSString *)getCurrentUDID                    {
    //	return [[UIDevice currentDevice] uniqueIdentifier];
    return @"";
}

+ (NSString *)getCurrentUUID                    {
    
    if ([SysUtils getOSVersion] < 60000) {
        
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        
        if (uuid == nil) {
            
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            uuid = [NSString stringWithString:(__bridge NSString *)string];
            CFRelease(string);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        return uuid;
    } else {
        
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
    }
    
}

+ (NSString *)getDeviceModel                    {
    return [NSString stringWithFormat:@"%@ (%@)", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
}

+ (NSInteger)getOSVersion                       {
    
    NSString* sOSVersion = [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"0"];
    
    if ([sOSVersion integerValue] < 10000)		// iOS 4.1부터는 버전 번호 자릿수가 3자리여서,
        return [sOSVersion integerValue] * 100;	// 5자리로 맞춰준다.
    else
        return [sOSVersion integerValue];
}

+ (NetworkStatus)getCurrentNetworkStatus        {
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    [wifiReach startNotifer];
    
    
    //Notification을 받기 위해 HostName으로 Reachability를 설정하자.
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.ibk.com"];
    [reachability startNotifer];
    
    return [wifiReach currentReachabilityStatus];
}

////=====================================================================================////
#pragma mark - Check Application -
////=====================================================================================////
+ (BOOL)applicationExecute:(NSString *)urlScheme    {
    if ([self isNull:urlScheme] == NO)
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    
    return NO;
}

+ (BOOL)canExecuteApplication:(NSString *)urlScheme {
    if ([self isNull:urlScheme] == YES)
        return NO;
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]];
}

////=====================================================================================////
#pragma mark - etc Method -
////=====================================================================================////
+ (BOOL)isPad   {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

+ (NSString *)md5String:(NSString*)userID currentsTime:(NSString*)currentTime{
    NSString *combinationWord = [NSString stringWithFormat:@"%@%@8DuwK+WJSghk_!49",userID,currentTime];
    
    //	const char *cStr = [self UTF8String];
    const char *cStr = [combinationWord UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)tempMd5String:(NSString*)testString   {
//    NSString *combinationWord = [NSString stringWithFormat:@"%@8DuwK+WJSghk_!49",testString];
    
//	const char *cStr = [self UTF8String];
    const char *cStr = [testString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSData *)md5tem:(NSString *)mD5                  {
    // Create pointer to the string as UTF8
    const char *ptr = [mD5 UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    unsigned char *ccmd5Buffer = CC_MD5(ptr, strlen(ptr), md5Buffer);

    NSData *md5Data = [[NSData alloc] initWithBytes:ccmd5Buffer length:sizeof(ccmd5Buffer)];

    return md5Data;
}

@end
