//
//  WCRViewCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRViewCourseWare.h"
#import "WCRCourseWareLogger.h"

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
}

- (void)setColor:(UIColor *)color{
    self.view.backgroundColor = color;
}
@end
