//
//  WCRImageCourseWareSpecs.m
//  WCRCourseWareSDKTests
//
//  Created by 欧阳铨 on 2019/4/26.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "WCRImageCourseWare.h"
#import "WCRError+ImageCourseWare.h"

SPEC_BEGIN(WCRImageCourseWareSpec)
describe(@"ImageCourseWare", ^{
    context(@"init courseWare", ^{
        it(@"should be a class and view should not be nil", ^{
            WCRImageCourseWare *courseWare = [[WCRImageCourseWare alloc] init];
            
            [[[courseWare class] should] equal:[WCRImageCourseWare class]];
            
            [[courseWare.view shouldNot] beNil];
        });
    });
    
    context(@"load image", ^{
        __block WCRImageCourseWare *courseWare = nil;
        __block id delegate = nil;
        
        beforeEach(^{
            courseWare = [[WCRImageCourseWare alloc] init];
            delegate = [KWMock mockForProtocol:@protocol(WCRCourseWareDelegate)];
            courseWare.delegate = delegate;
        });
        
        afterEach(^{
            courseWare = nil;
        });
        
        it(@"nil url should return error", ^{
            NSURL *url = [NSURL URLWithString:@""];
            WCRError *error = [courseWare loadImageWithURL:url];
            
            [[error.userInfo[NSLocalizedDescriptionKey] should] equal:[WCRError imageCourseWareErrorDescriptionWithCode:WCRImageErrorCodeNilUrl]];
        });
        
        it(@"should load success", ^{
            NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551333702362&di=af5a1e9a650537879185570862d68178&imgtype=0&src=http%3A%2F%2Fpic164.nipic.com%2Ffile%2F20180514%2F24821412_152755333000_2.jpg"];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareWillLoad:)];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareDidLoad:error:) withArguments:courseWare,nil];
            
            WCRError *error = [courseWare loadImageWithURL:url];
            
            [[error should] beNil];
            
            [[courseWare.imageView.image shouldNotEventuallyBeforeTimingOutAfter(5)] beNil];
        
            
            
        });
        
        it(@"should load fail", ^{
            NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/123.jpg"];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareWillLoad:)];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareDidLoad:error:) withArguments:courseWare,kw_any()];
            
            WCRError *error = [courseWare loadImageWithURL:url];
            
            [[error should] beNil];
            
            
            
        });
        
    });
});
SPEC_END
