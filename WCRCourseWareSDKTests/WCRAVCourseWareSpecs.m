//
//  WCRAVCourseWareSpecs.m
//  WCRCourseWareSDKTests
//
//  Created by 欧阳铨 on 2019/4/29.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "WCRAVCourseWare.h"
#import <WCRBase/WCRError.h>
#import "WCRError+AVCourseWare.h"

SPEC_BEGIN(WCRAVCourseWareSpec)

describe(@"WCRAVCourseWare", ^{
    context(@"init courseWare", ^{
        it(@"should be a class and view should not be nil", ^{
            
            WCRAVCourseWareScalingMode mode = WCRAVCourseWareScalingModeAspectFill;
            
            WCRAVCourseWare *courseWare = [[WCRAVCourseWare alloc] initWithScalingMode:mode];
            
            [[[courseWare class] should] equal:[WCRAVCourseWare class]];
            
            [[theValue(courseWare.scalingMode) should] equal:theValue(mode)];
            [[courseWare.error should] beNil];
            [[theValue(courseWare.status) should] equal:theValue(WCRAVCourseWarePlayStatusNone)];
            
            [[courseWare.view shouldNot] beNil];
        });
    });
    
    context(@"init courseWare", ^{
        it(@"blank url", ^{
            WCRAVCourseWare *courseWare = [[WCRAVCourseWare alloc] initWithScalingMode:WCRAVCourseWareScalingModeAspectFill];
            WCRError *error = [courseWare loadURL:[NSURL URLWithString:@""] withType:WCRAVCourseWareTypeVideo];
            
            [[error.userInfo[NSLocalizedDescriptionKey] should] equal:[WCRError avCourseWareErrorDescriptionWithCode:WCRAVErrorCodeNilUrl]];
        });
        
        it(@"correct url", ^{
            //AVCourseWare只是对WCRPlayer的封装，所有的方法都是对WCRPlayer的调用，故对加载、播放、暂停等方法不做测试，详细的测试参考WCRPlayer
        });
    });
});

SPEC_END
