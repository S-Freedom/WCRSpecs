//
//  WCRWebCourseWare+Test.h
//  WCRCourseWareSDKTests
//
//  Created by 欧阳铨 on 2019/4/29.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "WCRWebCourseWare.h"

@interface WCRWebCourseWare(test)
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableSet *messagesSet;
@property (nonatomic, copy) NSString *callBackJsString;
@property (nonatomic, assign, getter=isWebViewLoadSuccess) BOOL webViewLoadSuccess;
@end
