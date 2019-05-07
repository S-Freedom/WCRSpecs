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
#import <WCRCourseWareSDK/WCRCourseWare.h>

NS_ASSUME_NONNULL_BEGIN

/**
 当前音视频课件播放状态

 - WCRAVCourseWarePlayStatusNone: 无状态
 - WCRAVCourseWarePlayStatusReadyToPlay: 准备好播放
 - WCRAVCourseWarePlayStatusBuffering: 正在缓冲
 - WCRAVCourseWarePlayStatusDidSeek: seek完成
 - WCRAVCourseWarePlayStatusFinish: 播放结束
 - WCRAVCourseWarePlayStatusError: 播放错误，通过error属性获取错误详细信息
 */
typedef NS_ENUM(NSUInteger, WCRAVCourseWarePlayStatus) {
    WCRAVCourseWarePlayStatusNone = 0,
    WCRAVCourseWarePlayStatusReadyToPlay,
    WCRAVCourseWarePlayStatusBuffering,
    WCRAVCourseWarePlayStatusDidSeek,
    WCRAVCourseWarePlayStatusFinish,
    WCRAVCourseWarePlayStatusError
};

/**
 视频填充模式

 - WCRAVCourseWareScalingModeAspectFit: //适应全屏（可能会有空白区域）
 - WCRAVCourseWareScalingModeAspectFill: //充满全屏（可能有裁剪）
 */
typedef NS_ENUM(NSUInteger, WCRAVCourseWareScalingMode){
    WCRAVCourseWareScalingModeAspectFit = 0,
    WCRAVCourseWareScalingModeAspectFill
};


/**
 音视频类型

 - WCRAVCourseWareTypeAudio: 音频
 - WCRAVCourseWareTypeVideo: 视频
 */
typedef NS_ENUM(NSUInteger, WCRAVCourseWareType){
    WCRAVCourseWareTypeAudio = 0,
    WCRAVCourseWareTypeVideo
};

@class WCRAVCourseWare;
@protocol WCRAVCourseWareDelegate <NSObject>
@optional

/**
 音视频课件状态变化

 @param courseWare 状态变化的课件
 @param status 变化之后的状态
 */
- (void)avCourseWare:(WCRAVCourseWare *)courseWare statusChange:(WCRAVCourseWarePlayStatus)status;
@end

@interface WCRAVCourseWare : WCRCourseWare

/**
 音视频课件代理
 */
@property (nonatomic, weak) id<WCRAVCourseWareDelegate>avCourseWareDelegate;

/**
 具体错误内容
 */
@property (nonatomic, strong, readonly) WCRError *error;

/**
 当前课件状态
 */
@property (nonatomic, assign, readonly) WCRAVCourseWarePlayStatus status;

/**
 当前视频填充模式
 */
@property (nonatomic, assign, readonly) WCRAVCourseWareScalingMode scalingMode;

/**
 初始化音视频课件

 @param scalingMode 视频填充模式
 @return 课件实例
 */
- (instancetype)initWithScalingMode:(WCRAVCourseWareScalingMode)scalingMode;

/**
 加载音视频课件

 @param url 课件URL
 @param type 课件类型
 @return 方法是否执行成功
 */
- (WCRError * _Nullable)loadURL:(NSURL *)url withType:(WCRAVCourseWareType)type;

/**
 开始播放
 */
- (void)play;

/**
 停止播放
 */
- (void)stop;

/**
 暂停播放
 */
- (void)pause;

/**
 seek到某一时间

 @param time 需要跳转的时间（毫秒）
 */
- (void)seekToTime:(NSTimeInterval)time;

/**
 当前播放时间
 
 @return 当前播放时间（毫秒）
 */
- (NSTimeInterval)currentTime;


/**
 播放总时长
 @warning 需要在@see -courseWareDidLoad:error:;代理回调后获取，否则返回初始值0
 
 @return 总时长（毫秒）
 */
- (NSTimeInterval)totalTime;

/**
 当前缓冲区时长
 @warning 需要在@see -courseWareDidLoad:error:;代理回调后获取，否则返回初始值0
 
 */
- (NSTimeInterval)bufferDuration;
@end

NS_ASSUME_NONNULL_END
