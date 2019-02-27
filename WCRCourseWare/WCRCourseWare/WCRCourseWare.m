//
//  WCRCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/11/2.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRCourseWare.h"

@interface WCRCourseWare ()

@end

@implementation WCRCourseWare
-(instancetype)init{
    if (self = [super init]) {
        _backUpIndex = 0;
        _usingMainUrl = YES;
    }
    return self;
}

-(UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor clearColor];
    }
    return _view;
}

-(void)dealloc{
    [_view removeFromSuperview];
}

-(void)setUsingMainUrl:(BOOL)usingMainUrl{
    _usingMainUrl = usingMainUrl;
    if (usingMainUrl) {
        _usingOfflineUrl = NO;
    }
}

-(void)setUsingOfflineUrl:(BOOL)usingOfflineUrl{
    _usingOfflineUrl = usingOfflineUrl;
    if (usingOfflineUrl) {
        _usingMainUrl = NO;
    }
}

-(NSUInteger)retryInterval{
    NSUInteger ret = _retryInterval;
    if (_retryInterval == 0 || _retryInterval == 1) {
        _retryInterval++;
    }else if (_retryInterval < 8){
        _retryInterval += 2;
    }else{
        _retryInterval = 8;
    }
    return ret;
}

- (NSURL *)getBackUpUrl{
    if (_usingOfflineUrl) {
        //先用主url进行重试
        _usingMainUrl = YES;
        _usingOfflineUrl = NO;
        return _url;
    }
    
    if (_backUpIndex >= _backUpUrls.count) {
        _backUpIndex = 0;
        _usingMainUrl = YES;
        _usingOfflineUrl = NO;
        //备用url已经重试了一遍，使用主url
        return _url;
    }else{
        NSURL *url = [_backUpUrls objectAtIndex:_backUpIndex];
        _backUpIndex++;
        _usingMainUrl = NO;
        _usingOfflineUrl = NO;
        return url;
    }
}

@end
