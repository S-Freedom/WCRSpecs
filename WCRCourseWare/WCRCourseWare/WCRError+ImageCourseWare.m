//
//  WCRError+ImageCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/11/12.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRError+ImageCourseWare.h"

static NSString * const kWCRImageCourseWareErrorDomain = @"WCRImageCourseWareErrorDomain";


static NSString* const kWCRImageCourseWareErrorDescriptions[] = {
    @"无错误",             //WCRImageErrorCodeOK
    @"空图片地址",
    @"未知错误"              //WCRImageErrorCodeUnknown
};

@implementation WCRError(ImageCourseWare)
+ (NSString*)imageCourseWareErrorDescriptionWithCode:(WCRImageErrorCode)code{
    if(code <= WCRImageErrorCodeOK || code > WCRImageErrorCodeUnknown) {
        return @"";
    }
    return kWCRImageCourseWareErrorDescriptions[code];
}
+ (WCRError *)imageCourseWareErrorWithErrorCode:(WCRImageErrorCode)errorCode{
    NSDictionary* userInfo = @{
                               NSLocalizedDescriptionKey:[WCRError imageCourseWareErrorDescriptionWithCode:errorCode]
                               };
    return [WCRError errorWithDomain:kWCRImageCourseWareErrorDomain code:errorCode userInfo:userInfo];
}
+(WCRError *)imageCourseWareErrorWithNSError:(NSError *)error{
    return [WCRError errorWithDomain:kWCRImageCourseWareErrorDomain code:error.code userInfo:error.userInfo];
}
@end
