//
//  WCRError+WebCourseWare.h
//  WCRWebView
//
//  Created by 欧阳铨 on 2018/10/31.
//  Copyright © 2018 oyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCRBase/WCRError.h>

typedef NS_ENUM(NSUInteger, WCRWCWErrorCode) {
    WCRWCWErrorCodeOK = 0,

    WCRWCWErrorCodeJSError,
    WCRWCWErrorCodeNilUrl,
    WCRWCWErrorCodeUnknown
};

@interface WCRError(WebCourseWare)
+ (NSString*)webCourseWareErrorDescriptionWithCode:(WCRWCWErrorCode)code;
+ (WCRError *)webCourseWareErrorWithErrorCode:(WCRWCWErrorCode)errorCode;
+ (WCRError *)webCourseWareErrorWithNSError:(NSError *)error;
@end
