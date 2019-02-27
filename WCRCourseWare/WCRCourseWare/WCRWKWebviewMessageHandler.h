//
//  WCRWKWebviewMessageHandler.h
//  WCRWebView
//
//  Created by 欧阳铨 on 2018/10/31.
//  Copyright © 2018 oyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WCRWKWebviewMessageHandler : NSObject <WKScriptMessageHandler>
@property (nonatomic,weak)  id<WKScriptMessageHandler> delegate;
@end
