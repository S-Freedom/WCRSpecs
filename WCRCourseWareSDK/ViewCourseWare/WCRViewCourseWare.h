//
//  WCRViewCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WCRCourseWareSDK/WCRCourseWare.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCRViewCourseWare : WCRCourseWare

/**
 创建白板课件

 @param color 白板课件背景颜色
 */
- (void)createView:(UIColor *)color;

/**
 设置白板课件背景颜色

 @param color 背景颜色
 */
- (void)setColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
