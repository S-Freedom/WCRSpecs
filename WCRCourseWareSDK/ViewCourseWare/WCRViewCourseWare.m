//
//  WCRViewCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRViewCourseWare.h"
#import "WCRCourseWareLogger.h"
#import <WCRBase/ReactiveObjC.h>
#import <WCRBase/UIView+LayoutSubviewsCallback.h>

@interface WCRViewCourseWare ()
@property (assign, nonatomic) CGSize viewLastSize;
@end

@implementation WCRViewCourseWare
- (void)createView:(UIColor *)color{
    WCRCWLogInfo(@"创建白板");
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    self.view.backgroundColor = color;
    
    if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
        [self.delegate courseWareDidLoad:self error:nil];
    }
    self.viewLastSize = self.view.bounds.size;
    if (!self.view.layoutSubviewsCallback) {
        @weakify(self);
        self.view.layoutSubviewsCallback = ^(UIView * _Nonnull view) {
            @strongify(self);
            CGSize oldSize = self.viewLastSize;
            CGSize newSize = view.bounds.size;
            if (!CGSizeEqualToSize(oldSize, newSize)) {
                if ([self.viewCourseWareDelegate respondsToSelector:@selector(courseWare:viewSizeDidChange:)]) {
                    [self.viewCourseWareDelegate courseWare:self viewSizeDidChange:newSize];
                }
                self.viewLastSize = newSize;
            }
        };
    }
}

- (void)setColor:(UIColor *)color{
    self.view.backgroundColor = color;
}
@end
