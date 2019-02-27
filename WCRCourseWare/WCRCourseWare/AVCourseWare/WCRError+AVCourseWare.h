//
//  WCRError+AVCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/12/5.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCRBase/WCRError.h>

typedef NS_ENUM(NSUInteger, WCRAVErrorCode) {
    WCRAVErrorCodeOK = 0,
    
    WCRAVErrorCodeNilUrl,
    
    WCRAVErrorCodeUnknown
};

@interface WCRError(AVCourseWare)
+ (NSString*)avCourseWareErrorDescriptionWithCode:(WCRAVErrorCode)code;
+ (WCRError *)avCourseWareErrorWithErrorCode:(WCRAVErrorCode)errorCode;
+ (WCRError *)avCourseWareErrorWithNSError:(NSError *)error;
@end
