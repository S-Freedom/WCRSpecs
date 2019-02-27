//
//  WCRAVCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WCRCourseWare/WCRCourseWare.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCRAVCourseWarePlayStatus) {
    WCRAVCourseWarePlayStatusNone = 0,
    WCRAVCourseWarePlayStatusReadyToPlay,
    WCRAVCourseWarePlayStatusBuffering,
    WCRAVCourseWarePlayStatusDidSeek,
    WCRAVCourseWarePlayStatusFinish,
    WCRAVCourseWarePlayStatusError
};

typedef NS_ENUM(NSUInteger, WCRAVCourseWareScalingMode){
    WCRAVCourseWareScalingModeAspectFit = 0,//适应全屏（可能会有空白区域）
    WCRAVCourseWareScalingModeAspectFill //充满全屏（可能有裁剪）
};

typedef NS_ENUM(NSUInteger, WCRAVCourseWareType){
    WCRAVCourseWareTypeAudio = 0,//音频
    WCRAVCourseWareTypeVideo //视频
};

@class WCRAVCourseWare;
@protocol WCRAVCourseWareDelegate <NSObject>
@optional
- (void)avCourseWare:(WCRAVCourseWare *)courseWare statusChange:(WCRAVCourseWarePlayStatus)status;
@end

@interface WCRAVCourseWare : WCRCourseWare
@property (nonatomic, weak) id<WCRAVCourseWareDelegate>avCourseWareDelegate;
@property (nonatomic, strong, readonly) WCRError *error;
@property (nonatomic, assign, readonly) WCRAVCourseWarePlayStatus status;
- (instancetype)initWithScalingMode:(WCRAVCourseWareScalingMode)scalingMode;
- (WCRError * _Nullable)loadURL:(NSURL *)url withType:(WCRAVCourseWareType)type;
- (void)play;
- (void)stop;
- (void)pause;
- (void)seekToTime:(NSTimeInterval)time;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)totalTime;
- (NSTimeInterval)bufferDuration;
@end

NS_ASSUME_NONNULL_END
