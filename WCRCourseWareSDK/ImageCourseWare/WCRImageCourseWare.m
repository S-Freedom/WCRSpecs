//
//  WCRImageCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRImageCourseWare.h"
#import <WCRBase/UIImageView+WCRNetworking.h>
#import <WCRBase/ReactiveObjC.h>
#import <WCRBase/NSString+Utils.h>
#import "WCRError+ImageCourseWare.h"
#import "WCRCourseWareLogger.h"
#import "WCRCourseWare+Internal.h"


@interface WCRImageCourseWare ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WCRImageCourseWare

- (WCRError * _Nullable)loadImageWithURL:(NSURL *)url{
    WCRCWLogInfo(@"打开图片:%@",url);
    
    if (url == nil) {
        WCRCWLogError(@"加载图片 url为nil");
        return [WCRError imageCourseWareErrorWithErrorCode:WCRImageErrorCodeNilUrl];
    }
    
    if ([NSString wcr_isBlankString:url.absoluteString]) {
        WCRCWLogError(@"加载图片 url absoluteString 为空");
        return [WCRError imageCourseWareErrorWithErrorCode:WCRImageErrorCodeNilUrl];
    }
    
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    @weakify(self);
    [self.imageView wcr_setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        @strongify(self);
        WCRCWLogInfo(@"图片设置成功");
        [self.imageView setImage:image];
        if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
            [self.delegate courseWareDidLoad:self error:nil];
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        @strongify(self);
        WCRCWLogInfo(@"图片:%@ 设置失败:%@",url,error);
        if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
            [self.delegate courseWareDidLoad:self error:[WCRError imageCourseWareErrorWithNSError:error]];
        }
        
        [self retryAfterRetryInterval:self.retryInterval];
    }];
    return nil;
}

- (void)retryAfterRetryInterval:(NSUInteger)interval{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        NSURL *url = [self getBackUpUrl];
        WCRCWLogInfo(@"retryAfterRetryInterval:%lu url:%@",(unsigned long)interval,url);
        [self loadImageWithURL:url];
    });
    
}

-(UIView *)view{
    return self.imageView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

@end
