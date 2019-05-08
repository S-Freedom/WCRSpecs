//
//  WCRCourseWareSDK.h
//  WCRCourseWareSDK
//
//  Created by 欧阳铨 on 2019/3/4.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for WCRCourseWareSDK.
FOUNDATION_EXPORT double WCRCourseWareSDKVersionNumber;

//! Project version string for WCRCourseWareSDK.
FOUNDATION_EXPORT const unsigned char WCRCourseWareSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WCRCourseWareSDK/PublicHeader.h>


#if __has_include("WCRAVCourseWare.h")
#import <WCRCourseWareSDK/WCRAVCourseWare.h>
#endif

#if __has_include("WCRImageCourseWare.h")
#import <WCRCourseWareSDK/WCRImageCourseWare.h>
#endif

#if __has_include("WCRViewCourseWare.h")
#import <WCRCourseWareSDK/WCRViewCourseWare.h>
#endif

#if __has_include("WCRWebCourseWare.h")
#import <WCRCourseWareSDK/WCRWebCourseWare.h>
#endif

#import <WCRCourseWareSDK/WCRCourseWareLogger.h>
