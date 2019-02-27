//
//  WCRError+ImageCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/11/12.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCRBase/WCRError.h>

typedef NS_ENUM(NSUInteger, WCRImageErrorCode) {
    WCRImageErrorCodeOK = 0,
    
    WCRImageErrorCodeNilUrl,
    
    WCRImageErrorCodeUnknown
};

@interface WCRError(ImageCourseWare)
+ (NSString*)imageCourseWareErrorDescriptionWithCode:(WCRImageErrorCode)code;
+ (WCRError *)imageCourseWareErrorWithErrorCode:(WCRImageErrorCode)errorCode;
+ (WCRError *)imageCourseWareErrorWithNSError:(NSError *)error;
@end


