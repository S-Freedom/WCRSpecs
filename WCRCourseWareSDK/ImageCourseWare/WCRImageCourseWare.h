//
//  WCRImageCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WCRCourseWareSDK/WCRCourseWare.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCRImageCourseWare : WCRCourseWare

@property (nonatomic, strong, readonly) UIImageView *imageView;
- (WCRError * _Nullable)loadImageWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
