//
//  WCRCourseWare.h
//  WCRCourseWare
//
//  Created by 欧阳铨 on 2019/2/27.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for WCRCourseWare.
FOUNDATION_EXPORT double WCRCourseWareVersionNumber;

//! Project version string for WCRCourseWare.
FOUNDATION_EXPORT const unsigned char WCRCourseWareVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WCRCourseWare/PublicHeader.h>

#if __has_include("WCRAVCourseWare.h")
#import <WCRCourseWare/WCRAVCourseWare.h>
#endif

#if __has_include("WCRImageCourseWare.h")
#import <WCRCourseWare/WCRImageCourseWare.h>
#endif

#if __has_include("WCRViewCourseWare.h")
#import <WCRCourseWare/WCRViewCourseWare.h>
#endif

#if __has_include("WCRWebCourseWare.h")
#import <WCRCourseWare/WCRWebCourseWare.h>
#endif
