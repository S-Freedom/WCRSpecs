//
//  WCRCourseWareLog.h
//  WCRCourseWare
//
//  Created by 欧阳铨 on 2019/2/20.
//  Copyright © 2019 oyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCRBase/TALLogger.h>

NS_ASSUME_NONNULL_BEGIN

#define WCRCWLogPath @"Library/Caches/WCRLiveCoreLogs/CourseWare"
#define WCRCWLogInfo(fmt,...) AddLogInfo(fmt, TALLogFlagInfo, WCRCWLogPath,  24 * 60 * 60, 1024  * 1024 * 5, 5, ##__VA_ARGS__)
#define WCRCWLogError(fmt,...) AddLogInfo(fmt, TALLogFlagError, WCRCWLogPath,  24 * 60 * 60, 1024  * 1024 * 5, 5, ##__VA_ARGS__)
#define WCRCWLogWarn(fmt,...) AddLogInfo(fmt, TALLogFlagWarning, WCRCWLogPath,  24 * 60 * 60, 1024  * 1024 * 5, 5, ##__VA_ARGS__)

@interface WCRCourseWareLog : NSObject
+ (NSArray *)getLogFilePaths;
@end

NS_ASSUME_NONNULL_END
