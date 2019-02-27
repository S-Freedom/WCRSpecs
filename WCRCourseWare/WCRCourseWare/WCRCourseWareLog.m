//
//  WCRCourseWareLog.m
//  WCRCourseWare
//
//  Created by 欧阳铨 on 2019/2/20.
//  Copyright © 2019 oyq. All rights reserved.
//

#import "WCRCourseWareLog.h"

@implementation WCRCourseWareLog
+ (NSArray *)getLogFilePaths{
    return  [TALLogger getLogFilesWithPath:WCRCWLogPath];
}

@end
