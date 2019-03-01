//
//  WCRAVCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRAVCourseWare.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <WCRBase/NSString+Utils.h>
#import <WCRPlayer/Player.h>
#import "WCRCourseWareLog.h"
#import "WCRError+AVCourseWare.h"

@interface WCRAVCourseWare ()<WCRPlayerDelegate>
@property (nonatomic, strong) WCRError *error;
@property (nonatomic, strong) WCRPlayer *player;
@property (nonatomic, assign, getter=isPlayable) BOOL playable;
@property (nonatomic, assign) WCRAVCourseWarePlayStatus status;
@property (nonatomic, assign) WCRAVCourseWareScalingMode scalingMode;
@end

@implementation WCRAVCourseWare
-(instancetype)initWithScalingMode:(WCRAVCourseWareScalingMode)scalingMode{
    self = [super init];
    if (self) {
        _scalingMode = scalingMode;
    }
    return self;
}

-(void)dealloc{
    WCRCWLogInfo(@"WCRAVCourseWare dealloc");
    [_player destory];
    _player = nil;
}

-(WCRPlayer *)player{
    if (!_player) {
        WCRPlayerScalingMode mode;
        switch (_scalingMode) {
            case WCRAVCourseWareScalingModeAspectFit:
                mode = WCRPlayerScalingModeAspectFit;
                break;
            case WCRAVCourseWareScalingModeAspectFill:
                mode = WCRPlayerScalingModeAspectFit;
                break;
            default:
                break;
        }
        _player = [[WCRPlayer alloc] initWithPlayerSdk:WCRPlayerSDKTypeAVPlayer scalingMode:mode];
        _player.delegate = self;
    }
    return _player;
}

- (WCRError * _Nullable)loadURL:(NSURL *)url withType:(WCRAVCourseWareType)type{
    WCRCWLogInfo(@"加载视频:%@",url);
    if (url == nil) {
        WCRCWLogError(@"加载音视频 url为nil");
        return [WCRError avCourseWareErrorWithErrorCode:WCRAVErrorCodeNilUrl];
    }
    
    if ([NSString wcr_isBlankString:url.absoluteString]) {
        WCRCWLogError(@"加载音视频 url absoluteString 为空");
        return [WCRError avCourseWareErrorWithErrorCode:WCRAVErrorCodeNilUrl];
    }
    
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    switch (type) {
        case WCRAVCourseWareTypeAudio:
            [self.player create:nil];
            break;
        case WCRAVCourseWareTypeVideo:
            [self.player create:self.view];
            break;
            
        default:
            break;
    }
    [self.player loadURL:url];
    return nil;
}
- (void)play{
    WCRCWLogInfo(@"play:%@",self.url);
    [self.player play];
}
- (void)stop{
    WCRCWLogInfo(@"stop:%@",self.url);
    [self.player stop];
}
- (void)pause{
    WCRCWLogInfo(@"pause:%@",self.url);
    [self.player pause];
}
- (void)seekToTime:(NSTimeInterval)time{
    WCRCWLogInfo(@"seekToTime:%@ %f",self.url,time);
    if (fabs(time - self.currentTime) > 1000) {
        [self.player seekToTime:time];
    }else{
        WCRCWLogInfo(@"相差绝对值没有超过1秒");
    }
}
- (NSTimeInterval)currentTime{
    return self.player.currentTime;
}
- (NSTimeInterval)totalTime{
    return self.player.totalTime;
}
- (NSTimeInterval)bufferDuration{
    return self.player.bufferDuration;
}

-(void)player:(WCRPlayer *)player statusChange:(WCRPlayerStatus)status{
    WCRCWLogInfo(@"player:%@ statusChange:%lu",self.url,(unsigned long)status);
    switch (status) {
        case WCRPlayerStatusDidLoad:{
            if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
                [self.delegate courseWareDidLoad:self error:nil];
            }
            break;
        }
        case WCRPlayerStatusReadyToPlay:
            self.playable = YES;
            [self callBackStatusChange:WCRAVCourseWarePlayStatusReadyToPlay];
            break;
        case WCRPlayerStatusBuffering:
            [self callBackStatusChange:WCRAVCourseWarePlayStatusBuffering];
            break;
        case WCRPlayerStatusDidSeek:
            [self callBackStatusChange:WCRAVCourseWarePlayStatusDidSeek];
            break;
        case WCRPlayerStatusFinish:
            [self callBackStatusChange:WCRAVCourseWarePlayStatusFinish];
            break;
        case WCRPlayerStatusError:{
            self.error = self.player.error;
            [self callBackStatusChange:WCRAVCourseWarePlayStatusError];
            //重试播放
            self.playable = NO;
            [self retryAfterRetryInterval:self.retryInterval];
            break;
        }
        default:
            break;
    }
}

- (void)retryAfterRetryInterval:(NSUInteger)interval{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        NSURL *url = [self getBackUpUrl];
        WCRCWLogInfo(@"retryAfterRetryInterval:%lu url:%@",(unsigned long)interval,url);
        [self.player stop];
        [self.player loadURL:url];
        [self.player play];
    });
    
}

- (void)callBackStatusChange:(WCRAVCourseWarePlayStatus)status{
    self.status = status;
    if ([self.avCourseWareDelegate respondsToSelector:@selector(avCourseWare:statusChange:)]) {
        [self.avCourseWareDelegate avCourseWare:self statusChange:status];
    }
}

@end
