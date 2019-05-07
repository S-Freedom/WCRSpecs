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

/**
 课件即将被加载

 @param courseWare 被加载的课件
 */
- (void)courseWareWillLoad:(WCRCourseWare *)courseWare;

/**
 课件加载完成

 @param courseWare 被加载的课件
 @param error 加载过程中是否出现错误，nil表示加载成功
 */
- (void)courseWareDidLoad:(WCRCourseWare *)courseWare error:(WCRError * _Nullable)error;
@end

@interface WCRCourseWare : NSObject

/**
 课件的view
 */
@property (nonatomic, strong) UIView *view;

/**
 课件主URL
 */
@property (nonatomic, strong) NSURL *url;//主url

/**
 课件备用URL数组
 */
@property (nonatomic, strong) NSArray <NSURL *>*backUpUrls;//备用url数组

/**
 课件离线URL
 */
@property (nonatomic, strong, nullable) NSURL *offlineUrl;//离线url

/**
 是否正在用离线URL
 */
@property (nonatomic, assign, getter=isUsingOfflineUrl) BOOL usingOfflineUrl;//是否正在使用离线url

/**
 当前使用的备用URL数组index
 */
@property (nonatomic, assign) NSUInteger backUpIndex;//当前用的是backUrls的哪个index

/**
 是否正在用主URL
 */
@property (nonatomic, assign, getter=isUsingMainUrl) BOOL usingMainUrl;//是否正在使用主url

/**
 课件代理
 */
@property (nonatomic, weak) id <WCRCourseWareDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
