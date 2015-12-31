//
//  SingleTonManager.h
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTonManager : NSObject


@property (nonatomic) NSString* userID;
@property (nonatomic) NSString* passWord;
@property (nonatomic) NSString* user_file_name;
@property (nonatomic) NSString* user_lname;
@property (nonatomic) NSString* user_fname;

@property (nonatomic) NSDictionary *dicUserFriend;


+ (SingleTonManager *)ShareSingleTonManager;


@end
