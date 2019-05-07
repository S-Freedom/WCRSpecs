//
//  WCRCourseWare+Internal.h
//  WCRCourseWareSDK
//
//  Created by 欧阳铨 on 2019/5/7.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "WCRCourseWare.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCRCourseWare()

/**
 课件离线URL
 */
@property (nonatomic, strong, nullable) NSURL *offlineUrl;//离线url

/**
 当前使用的备用URL数组index
 */
@property (nonatomic, assign) NSUInteger backUpIndex;//当前用的是backUrls的哪个index

/**
 是否正在用离线URL
 */
@property (nonatomic, assign, getter=isUsingOfflineUrl) BOOL usingOfflineUrl;//是否正在使用离线url

/**
 是否正在用主URL
 */
@property (nonatomic, assign, getter=isUsingMainUrl) BOOL usingMainUrl;//是否正在使用主url

/**
 当前加载重试间隔
 */
@property (nonatomic, assign) NSUInteger retryInterval;//重试间隔

/**
 重试时使用，获取下一个重试URL
 
 @return 自动根据url和backUpUrls数组，计算出使用哪个url进行重试
 */
- (NSURL *)getBackUpUrl;
@end

NS_ASSUME_NONNULL_END
