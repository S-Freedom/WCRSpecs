//
//  WCRCourseWareLog.h
//  WCRCourseWare
//
//  Created by 欧阳铨 on 2019/2/20.
//  Copyright © 2019 oyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCRBase/WCRLogger.h>
#import <WCRBase/WCRBaseLog.h>

NS_ASSUME_NONNULL_BEGIN

#define WCRCWLogPath  [WCRCourseWareLogger sharedLogger].logFilePath
#define WCRCWLogFrameWorkName  [WCRCourseWareLogger sharedLogger].SDKName
#define WCRCWLogEncryptBlock   [WCRCourseWareLogger sharedLogger].encryptBlock

#define WCRCWLogInfo(fmt,...) AddLogInfo(fmt, WCRLogFlagInfo,WCRCWLogPath, WCRCWLogFrameWorkName,  24 * 60 * 60, 1024  * 1024 * 5, 5,WCRCWLogEncryptBlock, ##__VA_ARGS__)
#define WCRCWLogError(fmt,...) AddLogInfo(fmt, WCRLogFlagError, WCRCWLogPath, WCRCWLogFrameWorkName, 24 * 60 * 60, 1024  * 1024 * 5, 5,WCRCWLogEncryptBlock, ##__VA_ARGS__)
#define WCRCWLogWarn(fmt,...) AddLogInfo(fmt, WCRLogFlagWarning, WCRCWLogPath, WCRCWLogFrameWorkName, 24 * 60 * 60, 1024  * 1024 * 5, 5,WCRCWLogEncryptBlock, ##__VA_ARGS__)

@interface WCRCourseWareLogger : WCRBaseLog
+ (instancetype)sharedLogger;
@end

NS_ASSUME_NONNULL_END
