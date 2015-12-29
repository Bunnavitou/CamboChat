//
//  DateUtils.h
//  JobTesting
//
//  Created by Yoman on 7/6/15.
//  Copyright (c) 2015 AlwasyHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(DateUtils)

- (NSString *)dateToString:(NSString *)format;

- (NSString *)dateToString:(NSString *)format localeIdentifier:(NSString *)localeIdentifier;

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)hour24;

- (NSInteger)minute;

- (NSInteger)quarter;

- (NSInteger)second;

- (NSDate *)addYear:(NSInteger)years;

- (NSDate *)addMonth:(NSInteger)months;

- (NSDate *)addDay:(NSInteger)days;

- (NSDate *)addHours:(NSInteger)hours;

- (NSDate *)firstDayOfMonth;

- (NSDate *)lastDayOfMonth;

- (NSInteger)dayOfWeek;

- (NSString *)lunarDateToStringMMdd:(NSString *)seperate;

- (NSInteger)lunarDateYear;

- (NSInteger)lunarDateMonth;

- (NSInteger)lunarDateDay;

- (NSDate *)setDateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (BOOL)isEarlierThan:(NSDate *)date;

- (BOOL)isLaterThan:(NSDate *)date;

- (NSString *)koreanDayName;

@end

