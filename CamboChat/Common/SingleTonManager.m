//
//  SingleTonManager.m
//  JobFood
//
//  Created by Yoman on 6/25/15.
//  Copyright (c) 2015 Yoman. All rights reserved.
//

#import "SingleTonManager.h"


@implementation SingleTonManager


static SingleTonManager *singleMgr = nil;

+ (SingleTonManager *)ShareSingleTonManager {
    if (singleMgr == nil)
        singleMgr = [[SingleTonManager alloc] init];
    
    return singleMgr;
}



@end
