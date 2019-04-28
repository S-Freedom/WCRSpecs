//
//  WCRViewCourseWare.m
//  WCRCourseWareSDKTests
//
//  Created by 欧阳铨 on 2019/4/26.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "WCRViewCourseWare.h"

SPEC_BEGIN(WCRViewCourseWareSpec)
describe(@"WCRViewCourseWare", ^{
    context(@"init courseWare", ^{
        it(@"should be a class and view should not be nil", ^{
            WCRViewCourseWare *courseWare = [[WCRViewCourseWare alloc] init];
            
            [[[courseWare class] should] equal:[WCRViewCourseWare class]];
            
            [[courseWare.view shouldNot] beNil];
        });
    });
    
    context(@"create View", ^{
        __block WCRViewCourseWare *courseWare = nil;
        __block id delegate = nil;
        
        beforeEach(^{
            courseWare = [[WCRViewCourseWare alloc] init];
            delegate = [KWMock mockForProtocol:@protocol(WCRCourseWareDelegate)];
            courseWare.delegate = delegate;
        });
        
        afterEach(^{
            courseWare = nil;
        });
        
        it(@"should call back ", ^{
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareWillLoad:)];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareDidLoad:error:) withArguments:courseWare,nil];
            
            UIColor *color = [UIColor redColor];
            
            [courseWare createView:color];
            
            [[courseWare.view.backgroundColor should] equal:color];
            
        });
    });
});
SPEC_END
