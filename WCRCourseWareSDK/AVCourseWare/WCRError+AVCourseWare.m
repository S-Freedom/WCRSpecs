//
//  WCRError+AVCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/12/5.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRError+AVCourseWare.h"

static NSString * const kWCRAVCourseWareErrorDomain = @"WCRAVCourseWareErrorDomain";


static NSString* const kWCRAVCourseWareErrorDescriptions[] = {
    @"无错误",             //WCRAVErrorCodeOK
    @"空音视频地址",
    @"未知错误"              //WCRAVErrorCodeUnknown
};

@implementation WCRError(AVCourseWare)
+ (NSString*)avCourseWareErrorDescriptionWithCode:(WCRAVErrorCode)code{
    if(code <= WCRAVErrorCodeOK || code > WCRAVErrorCodeUnknown) {
        return @"";
    }
    return kWCRAVCourseWareErrorDescriptions[code];
}
+ (WCRError *)avCourseWareErrorWithErrorCode:(WCRAVErrorCode)errorCode{
    NSDictionary* userInfo = @{
                               NSLocalizedDescriptionKey:[WCRError avCourseWareErrorDescriptionWithCode:errorCode]
                               };
    return [WCRError errorWithDomain:kWCRAVCourseWareErrorDomain code:errorCode userInfo:userInfo];
}
+ (WCRError *)avCourseWareErrorWithNSError:(NSError *)error{
    return [WCRError errorWithDomain:kWCRAVCourseWareErrorDomain code:error.code userInfo:error.userInfo];
}
@end
