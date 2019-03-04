//
//  WCRCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/11/2.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCRCourseWare;
@class WCRError;
@protocol WCRCourseWareDelegate <NSObject>
@optional
- (void)courseWareWillLoad:(WCRCourseWare *)courseWare;
- (void)courseWareDidLoad:(WCRCourseWare *)courseWare error:(WCRError * _Nullable)error;
@end

@interface WCRCourseWare : NSObject
@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) NSURL *url;//主url
@property (nonatomic, strong, nullable) NSURL *offlineUrl;//离线url
@property (nonatomic, strong) NSArray <NSURL *>*backUpUrls;//备用url数组
@property (nonatomic, assign) NSUInteger backUpIndex;//当前用的是backUrls的哪个index
@property (nonatomic, assign, getter=isUsingOfflineUrl) BOOL usingOfflineUrl;//是否正在使用离线url
@property (nonatomic, assign, getter=isUsingMainUrl) BOOL usingMainUrl;//是否正在使用主url
@property (nonatomic, assign) NSUInteger retryInterval;//重试间隔

@property (nonatomic, weak) id <WCRCourseWareDelegate> delegate;

/**
 重试时使用

 @return 自动根据url和backUpUrls数组，计算出使用哪个url进行重试
 */
- (NSURL *)getBackUpUrl;
@end

NS_ASSUME_NONNULL_END
