//
//  WCRWebCourseWareSpecs.m
//  WCRCourseWareSDKTests
//
//  Created by 欧阳铨 on 2019/4/29.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "WCRWebCourseWare.h"
#import "WCRWebCourseWare+Test.h"
#import "WCRError+WebCourseWare.h"

SPEC_BEGIN(WCRWebCourseWareSpec)
describe(@"WCRAVCourseWare", ^{
    context(@"init courseWare", ^{
        it(@"should be a class and view should not be nil", ^{
            WCRWebCourseWare *courseWare = [[WCRWebCourseWare alloc] init];
            
            [[[courseWare class] should] equal:[WCRWebCourseWare class]];
            
            [[courseWare.view shouldNot] beNil];
        });
    });
    
    context(@"init courseWare", ^{
        it(@"blank url", ^{
            WCRWebCourseWare *courseWare = [[WCRWebCourseWare alloc] init];
            WCRError *error = [courseWare loadURL:[NSURL URLWithString:@""]];
            
            [[error.userInfo[NSLocalizedDescriptionKey] should] equal:[WCRError webCourseWareErrorDescriptionWithCode:WCRWCWErrorCodeNilUrl]];
        });
        
        it(@"correct url", ^{
            NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
            id delegate = [KWMock mockForProtocol:@protocol(WCRCourseWareDelegate)];
            
            WCRWebCourseWare *courseWare = [[WCRWebCourseWare alloc] init];
            courseWare.delegate = delegate;
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareWillLoad:)];
            
            [[delegate shouldEventuallyBeforeTimingOutAfter(5)] receive:@selector(courseWareDidLoad:error:) withArguments:courseWare,nil];
            
            WCRError *error = [courseWare loadURL:url];
            
            [[error should] beNil];
        });
        
    });
    
    context(@"call js function", ^{
        __block WCRWebCourseWare *courseWare = nil;
        beforeAll(^{
            courseWare = [[WCRWebCourseWare alloc] init];
            
            courseWare.webViewLoadSuccess = YES;
            
        });
        
        afterAll(^{
            courseWare = nil;
        });
        
        it(@"goToPage", ^{
            [[courseWare.webView should] receive:@selector(evaluateJavaScript:completionHandler:) withArguments:kw_any(),kw_any()];
            
            [courseWare goToPage:2 step:2];
            
        });
        
        it(@"page scroll", ^{
            [[courseWare.webView should] receive:@selector(evaluateJavaScript:completionHandler:) withArguments:kw_any(),kw_any()];
            
            [courseWare page:2 scrollToRate:0.5];
            
           
        });
        
        it(@"mouse click", ^{
            [[courseWare.webView should] receive:@selector(evaluateJavaScript:completionHandler:) withArguments:kw_any(),kw_any()];
            
            [courseWare mouseClick:CGRectZero];
        });
        
        it(@"sendMessage", ^{
            [[courseWare.webView should] receive:@selector(evaluateJavaScript:completionHandler:) withArguments:kw_any(),nil];
            
            courseWare.callBackJsString = @"temp";
            
            [courseWare sendMessage:@"123" withBody:[NSDictionary dictionary] completionHandler:nil];
        });
    });
    
    context(@"call function", ^{
        __block WCRWebCourseWare *courseWare = nil;
        beforeAll(^{
            courseWare = [[WCRWebCourseWare alloc] init];
        });
        
        afterAll(^{
            courseWare = nil;
        });
        
        it(@"registerMessage", ^{
            NSString *msgName = @"msgName";
            
            [[courseWare.messagesSet should] receive:@selector(addObject:) withArguments:msgName];
            
            [courseWare registerMessageWithMessageName:msgName];
            
        });
        
        it(@"unregisterMessage", ^{
            NSString *msgName = @"msgName";
            
            [[courseWare.messagesSet should] receive:@selector(removeObject:) withArguments:msgName];
            
            [courseWare unregisterMessageWithMessageName:msgName];
            
        });
        
        it(@"allRegisterMessages", ^{
            [[courseWare.messagesSet should] receive:@selector(allObjects)];
            
            [courseWare allRegisterMessages];
            
        });
    });
    
    
    
    
});
SPEC_END
