//
//  StrUtils.h
//  JobTesting
//
//  Created by Yoman on 7/6/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
enum  {
    ALGORITHM_AES256 = 0,
    ALGORITHM_AES128,
    ALGORITHM_AES256WITHMD5
};
typedef NSUInteger CRYPTO_ALPORITHM;

@interface NSString(StrUtils)

- (NSString *)trim;

- (BOOL)isAlphaNumeric;

- (BOOL)isntSpecialCharacter;

- (NSString *)setCurrencyFormat;

- (NSString *)setCurrencyFloatFormat;

- (NSString *)setNumberFloatFormat;

- (NSString *)sha1String;

- (NSString *)sha1EncodeBase64String;

- (NSString *)sha256String;

- (NSString *)sha256EncodeBase64String;

- (NSString *)sha512String;

- (NSString *)sha512EncodeBase64String;

- (NSString *)md5String;

- (NSString *)base64EncodeWithString:(NSString *)plainString;

- (NSString *)base64EncodeWithData:(NSData *)plainData;

- (NSString *)base64DecodeWithString:(NSString *)Base64String;

- (NSData *)base64DecodeData:(NSString *)Base64String;

- (NSArray *)csvRows;

- (CGFloat)measureTextHeight:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedToSize;

- (CGFloat)measureTextWidth:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedToSize;

+ (NSDateFormatter*)stringDateFormatter;

+ (NSDate*)stringDateFromString:(NSString*)string;

+ (NSString*)stringDateFromDate:(NSDate*)date;


@end
