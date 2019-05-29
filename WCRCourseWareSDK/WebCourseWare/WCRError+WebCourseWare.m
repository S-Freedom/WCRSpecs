//
//  WCRError+WebCourseWare.m
//  WCRWebView
//
//  Created by 欧阳铨 on 2018/10/31.
//  Copyright © 2018 oyq. All rights reserved.
//

#import "WCRError+WebCourseWare.h"

static NSString * const kWCRWebCourseWareErrorDomain = @"WCRWebCourseWareErrorDomain";


static NSString* const kWCRWebCourseWareErrorDescriptions[] = {
    @"无错误",             //WCRLSErrorCodeOK
    @"JS内部错误",
    @"空网页地址",
    @"地址scheme为空",
    @"未知错误"              //WCRLSErrorCodeUnknown
};

@implementation WCRError(WebCourseWare)
+ (NSString*)webCourseWareErrorDescriptionWithCode:(WCRWCWErrorCode)code{
    if(code <= WCRWCWErrorCodeOK || code > WCRWCWErrorCodeUnknown) {
        return @"";
    }
    return kWCRWebCourseWareErrorDescriptions[code];
}
+ (WCRError *)webCourseWareErrorWithErrorCode:(WCRWCWErrorCode)errorCode{
    NSDictionary* userInfo = @{
                               NSLocalizedDescriptionKey:[WCRError webCourseWareErrorDescriptionWithCode:errorCode]
                               };
    return [WCRError errorWithDomain:kWCRWebCourseWareErrorDomain code:errorCode userInfo:userInfo];
}
+(WCRError *)webCourseWareErrorWithNSError:(NSError *)error{
    return [WCRError errorWithDomain:kWCRWebCourseWareErrorDomain code:error.code userInfo:error.userInfo];
}
@end
