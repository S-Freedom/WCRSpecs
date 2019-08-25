//
//  WCRWebCourseWare.m
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import "WCRWebCourseWare.h"
#import <WCRBase/WCRYYModel.h>
#import <WCRBase/ReactiveObjC.h>
#import <WCRBase/NSString+Utils.h>
#import <WCRBase/NSDictionary+Utils.h>
#import <WCRBase/UIView+LayoutSubviewsCallback.h>
#import "WCRCourseWareLogger.h"
#import "WCRCouerseWareWKWebviewMessageHandler.h"
#import "WCRError+WebCourseWare.h"
#import "WCRCourseWare+Internal.h"

static NSString * const kWCRDocJSSDKScriptMessageHandler = @"WCRDocJSSDK";
NSString * const kWCRWebCourseWareJSFuncSetUp = @"setup";
NSString * const kWCRWebCourseWareJSFuncSendMessage = @"sendMessage";
NSString * const kWCRWebCourseWareJSFuncSendMessageWithCallBack = @"sendMessageWithCallback";
NSString * const kWCRWebCourseWareJSErrorMessage = @"BUFFERING_LOAD_ERROR";
//PDF课件高度通知
NSString * const kWCRWebCourseWareJSScrollMessage = @"PDF_SCROLLTOP_RESULT";
NSString * const kWCRWebCourseWareJSHeightChangeMessage = @"PDF_PAGECONTENT_HEIGHT";
//题库与课件高度通知
NSString * const kWCRWebCourseWareJSDOCScrollMessage = @"DOCQS_SCROLLTOP_RESULT";
NSString * const kWCRWebCourseWareJSDOCHeightChangeMessage = @"DOCQS_PAGECONTENT_HEIGHT";
//课件壳打印日志消息
NSString * const kWCRWebCourseWareJSWebLog = @"web_log";

@interface WCRWebCourseWare ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableSet *messagesSet;
@property (nonatomic, copy) NSString *callBackJsString;
@property (nonatomic, assign, getter=isWebViewLoadSuccess) BOOL webViewLoadSuccess;
@property (nonatomic, strong) NSMutableArray *messageNames;
@property (nonatomic, strong) NSMutableArray *messageBodys;
@property (nonatomic, strong) NSMutableArray *evaluateJaveScripts;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, assign) CGFloat currentRate;
@property (nonatomic, assign) CGFloat documentHeight;
@property (nonatomic, assign) CGSize webViewLastSize;
@end

@implementation WCRWebCourseWare
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initParams];
    }
    return self;
}

- (void)initParams{
    self.currentPage = 1;
    self.currentStep = -1;
    self.documentHeight = 0;
    self.currentRate = 0;
    self.currentOffset = CGPointZero;
}

-(void)dealloc{
    WCRCWLogInfo(@"WCRWebCourseWare dealloc");
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:kWCRDocJSSDKScriptMessageHandler];
    //iOS8中销毁webView时奔溃
    _webView.scrollView.delegate = nil;
}

- (WCRError * _Nullable)loadURL:(NSURL *)url{
    WCRCWLogInfo(@"打开课件:%@ ,%@",url,[url class]);
    self.view = self.webView;
    
    if (url == nil) {
        WCRCWLogError(@"打开课件 url为nil");
        return [WCRError webCourseWareErrorWithErrorCode:WCRWCWErrorCodeNilUrl];
    }
    
    if ([NSString wcr_isBlankString:url.absoluteString]) {
        WCRCWLogError(@"打开课件 url absoluteString 为空");
        return [WCRError webCourseWareErrorWithErrorCode:WCRWCWErrorCodeNilUrl];
    }
    
    if ([NSString wcr_isBlankString:url.scheme]) {
        WCRCWLogError(@"打开课件 url scheme 为空");
        return [WCRError webCourseWareErrorWithErrorCode:WCRWCWErrorCodeNilScheme];
    }
    
    //记录此时webview的size
    self.webViewLastSize = self.webView.bounds.size;
    if (!self.webView.layoutSubviewsCallback) {
        @weakify(self);
        self.webView.layoutSubviewsCallback = ^(UIView * _Nonnull view) {
            @strongify(self);
            //当前webview的size变化时，pdf课件不会自适应，需要刷新一下webView
            CGSize oldSize = self.webViewLastSize;
            CGSize newSize = view.bounds.size;
            if (!CGSizeEqualToSize(oldSize, newSize)) {
                WCRCWLogInfo(@"size 改变造成webView reload %@ %@",NSStringFromCGSize(oldSize),NSStringFromCGSize(newSize));
                if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
                    [self.delegate courseWareWillLoad:self];
                }
                [self initParams];
                [self.webView reload];
            }
            self.webViewLastSize = newSize;
        };
    }
    
    self.webViewLoadSuccess = NO;
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    return nil;
}

-(void)setUserScrollEnable:(BOOL)userScrollEnable{
    _userScrollEnable = userScrollEnable;
    self.webView.scrollView.scrollEnabled = userScrollEnable;
}

- (void)goToPage:(NSInteger)page step:(NSInteger)step{
    WCRCWLogInfo(@"课件翻页page:%lu step:%lu",(unsigned long)page,(unsigned long)step);
    if (page <= 0 || step == -1){
        WCRCWLogError(@"page小于0或者step等于-1");
        return;
    }
    if (page == self.currentPage && step == self.currentStep) {
        WCRCWLogInfo(@"已经是当前页的某一步");
        return;
    }
    self.currentPage = page;
    self.currentStep = step;
    NSString* toPageScript = [NSString stringWithFormat:
                              @"if (window.slideAPI) {"
                              "    window.slideAPI.gotoSlideStep(%d, %d);"
                              "} else {"
                              "    window.enableGotoSlide = true; "
                              "    window.gotoSlide(%d, %d);"
                              "}"
                              , (int)(page-1), (int)(step), (int)(page-1), (int)(step)];
    if (self.isWebViewLoadSuccess) {
        [self evaluateJavaScript:toPageScript completionHandler:nil];
    }else{
        [self.evaluateJaveScripts addObject:toPageScript];
    }
    
}

- (void)page:(NSInteger)page scrollToRate:(CGFloat)rate{
    WCRCWLogInfo(@"某页滚动page:%lu scrollToRate:%f",(unsigned long)page,rate);
    if (page != self.currentPage) {
        WCRCWLogError(@"page不等于当前页");
        return;
    }
    if (rate <0.0f || rate > 1.0f) {
        WCRCWLogError(@"rate <0.0或者rate > 1.0");
        return;
    }
    //记录当前滚动比例
    self.currentRate = rate;
    
    if (self.isWebViewLoadSuccess) {
        if (self.documentHeight != 0) {
            //判断高度不等于0，防止没有回调高度就进行滚动，导致滚动的位置不正确
            NSString* rateScript = [NSString stringWithFormat:@"window.slideAPI.scrollTo(%d);", (int)(rate * self.documentHeight)];
            [self evaluateJavaScript:rateScript completionHandler:nil];
            
            //如果scrollView当前偏移和需要滚动的偏移一样，是不会走scrollViewDidScroll回调的，这里需要手动回调一下
            //修复问题。只有一个课件涂鸦区域的时候，打开A课件滚动到500，再打开B课件滚动到0，此时切回A课件，还是滚动到500，但是没有scrollView滚动的回调，导致涂鸦的偏移还是停留在B课件的0的位置。
            if (CGPointEqualToPoint(self.webView.scrollView.contentOffset, CGPointMake(0, (int)(rate * self.documentHeight)))) {
                WCRCWLogInfo(@"主动调用scrollViewDidScroll :%@",NSStringFromCGPoint(self.webView.scrollView.contentOffset));
                [self scrollViewDidScroll:self.webView.scrollView];
            }
            
        }else{
            WCRCWLogInfo(@"滚动时没有高度回调");
            //如果高度为0，证明课件还没有通知我们高度。
            //这时候等高度的通知：onJsFuncHeightChange。再根据存起来的self.currentRate，计算一下滚动高度，调用滚动
        }
        
    }else{
        WCRCWLogInfo(@"滚动时webview未加载完成");
        //这里不需要判断高度是否为0，因为还没有WebViewLoadSuccess，肯定没有回调高度
        //这时候等高度的通知：onJsFuncHeightChange。再根据存起来的self.currentRate，计算一下滚动高度，调用滚动
    }
    
}

- (void)mouseClick:(CGRect)click{
    WCRCWLogInfo(@"模拟鼠标点击 x:%f y:%f w:%f h:%f",click.origin.x,click.origin.y,click.size.width,click.size.height);
    CGFloat webViewWidth = self.webView.bounds.size.width;
    CGFloat webViewHeight = self.webView.bounds.size.height;
    
    CGFloat x = click.origin.x;
    CGFloat y = click.origin.y;
    CGFloat w = click.size.width;
    CGFloat h = click.size.height;
    
    CGFloat newX = webViewWidth * x / w;
    CGFloat newY = webViewHeight * y / h;
    NSString *mouseClickScript = [NSString stringWithFormat:@"mouse_click(%d,%d)",(int)newX,(int)newY];
    if (self.isWebViewLoadSuccess) {
        [self evaluateJavaScript:mouseClickScript completionHandler:nil];
    }else{
        [self.evaluateJaveScripts addObject:mouseClickScript];
    }
}

- (void)executeCallBackAfterMessage {
    WCRCWLogInfo(@"executeCallBackAfterMessage");
    for (int i = 0; i< self.messageNames.count; i++) {
        NSString* content = [NSString stringWithFormat:@"{\"msg\":\"%@\", \"body\":%@}", self.messageNames[i], [NSString wcr_jsonWithDictionary:self.messageBodys[i]]];
        NSString *js = [NSString stringWithFormat:@"try{%@(%@);}catch(e){window.WCRDocSDK.log(e);}", self.callBackJsString, content];
        [self evaluateJavaScript:js completionHandler:nil];
    }
    [self.messageNames removeAllObjects];
    [self.messageBodys removeAllObjects];
}
- (void)syncJSAction{
     //TODO  需要做消息保序操作。
    if (self.messageNames.count && self.messageBodys.count &&self.callBackJsString) {
        [self executeCallBackAfterMessage];
    }
    for (NSString *js in self.evaluateJaveScripts) {
        [self evaluateJavaScript:js completionHandler:nil];
    }
    [self.evaluateJaveScripts removeAllObjects];
}

- (void)registerMessageWithMessageName:(NSString *)messageName{
    [self.messagesSet addObject:messageName];
}
- (void)unregisterMessageWithMessageName:(NSString *)messageName{
    [self.messagesSet removeObject:messageName];
}
- (void)unregisterAllMessages{
    [self.messagesSet removeAllObjects];
}
- (NSArray *)allRegisterMessages{
    return [self.messagesSet allObjects];
}

- (void)sendMessage:(NSString *)messageName withBody:(NSDictionary *)messageBody completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    if (![NSString wcr_isBlankString:self.callBackJsString]) {
        NSString* content = [NSString stringWithFormat:@"{\"msg\":\"%@\", \"body\":%@}", messageName, [NSString wcr_jsonWithDictionary:messageBody]];
        
        NSString *js = [NSString stringWithFormat:@"try{%@(%@);}catch(e){window.WCRDocSDK.log(e);}", self.callBackJsString, content];
        [self evaluateJavaScript:js completionHandler:completionHandler];
    } else {
        if (![NSString wcr_isBlankString:messageName]) {
            [self.messageNames addObject:messageName];
            if (messageBody != nil) {
                [self.messageBodys addObject:messageBody];
            } else {
                [self.messageBodys addObject:@{}];
            }
        }
        WCRCWLogError(@"callBackJsString为空 messageName:%@ messageBody:%@",messageName,messageBody);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"WCRDocJSSDK"]) {
        NSString* msgBodyString = (NSString*)message.body;
        NSDictionary* msgBody = [NSDictionary wcr_dictionaryWithJSON:msgBodyString];
        NSString* msgName = [msgBody objectForKey:@"message"];
        WCRCWLogInfo(@"收到WCRDocJSSDK消息:%@ msgBody:%@",msgName,msgBody);
        if ([msgName isEqualToString:kWCRWebCourseWareJSFuncSetUp]) {
            [self onJsFuncSetUp:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSFuncSendMessage]) {
            [self onJsFuncSendMessage:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSFuncSendMessageWithCallBack]) {
            [self onJsFuncSendMessageWithCallBack:msgBody];
        }else if ([msgName isEqualToString:kWCRWebCourseWareJSErrorMessage]) {
            [self onJsFuncError:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSScrollMessage]) {
            [self onJsFuncScroll:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSHeightChangeMessage]) {
            [self onJsFuncHeightChange:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSDOCScrollMessage]) {
            [self onJsFuncScroll:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSDOCHeightChangeMessage]) {
            [self onJsFuncHeightChange:msgBody];
        } else if ([msgName isEqualToString:kWCRWebCourseWareJSWebLog]){
            [self onJsFuncWebLog:msgBody];
        }
        [self callBackJsFunc:msgName body:msgBody];
    }else{
        WCRCWLogInfo(@"收到非WCRDocJSSDK消息:%@",message.name);
    }
}
- (void)callBackJsFunc:(NSString *)name body:(NSDictionary *)body{
    if ([self.messagesSet containsObject:name]) {
        if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWare:receiveMessage:withBody:)]) {
            [self.webCourseDelegate webCourseWare:self receiveMessage:name withBody:body];
        }
    }
}

- (void)onJsFuncSetUp:(NSDictionary *)message{
    NSDictionary *config = [message objectForKey:@"body"];
    if (config == nil) {
        WCRCWLogError(@"setUp方法config为空");
        return;
    }
    self.callBackJsString = [config objectForKey:@"msg_callback"];
    
    NSString *callBack = [message objectForKey:@"callback"];
    
    if (callBack == nil) {
        WCRCWLogError(@"setUp方法callBack为空");
        return;
    }
    
    
    if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWareSetUpDocumentMessageDictionary:)]) {
        NSDictionary *callbackContent = [self.webCourseDelegate webCourseWareSetUpDocumentMessageDictionary:self];
        NSString* callbackMsg = [NSString stringWithFormat:@"try{%@(%@);}catch(e){window.WCRDocSDK.log(e);}"
                                 , callBack
                                 , [NSString wcr_jsonWithDictionary:callbackContent]];
        [self evaluateJavaScript:callbackMsg completionHandler:nil];
    }
    
    //nova课件，教研云课件等走setUp回调的课件，在此同步翻页等操作
    [self syncJSAction];
}

- (void)onJsFuncSendMessage:(NSDictionary *)message{
    NSDictionary *body = [message objectForKey:@"body"];
    if (body == nil) {
        WCRCWLogError(@"body 为空");
        return;
    }
    
    NSString* msgName = [body objectForKey:@"msg"];
    NSDictionary* msgBody = [body objectForKey:@"body"];
    
    if ([NSString wcr_isBlankString:msgName] || msgBody == nil) {
        WCRCWLogError(@"megName:%@ 或者 msgBody:%@为空",msgName,msgBody);
        return;
    }
    
    if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWare:sendDocMessage:withBody:completion:)]) {
        [self.webCourseDelegate webCourseWare:self sendDocMessage:msgName withBody:msgBody completion:nil];
    }
    
}

- (void)onJsFuncSendMessageWithCallBack:(NSDictionary *)message{
    NSDictionary *body = [message objectForKey:@"body"];
    if (body == nil) {
        WCRCWLogError(@"body 为空");
        return;
    }
    
    NSString* msgName = [body objectForKey:@"msg"];
    NSDictionary* msgBody = [body objectForKey:@"body"];
    
    if ([NSString wcr_isBlankString:msgName] || msgBody == nil) {
        WCRCWLogError(@"megName:%@ 或者 msgBody:%@为空",msgName,msgBody);
        return;
    }
    
    NSString* callback = [message objectForKey:@"callback"];
    
    if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWare:sendDocMessage:withBody:completion:)]) {
        if ([NSString wcr_isBlankString:callback]) {
            [self.webCourseDelegate webCourseWare:self sendDocMessage:msgName withBody:msgBody completion:nil];
        }else{
            [self.webCourseDelegate webCourseWare:self sendDocMessage:msgName withBody:msgBody completion:^(NSDictionary * _Nonnull dict) {
                NSString *jsonData = @"";
                if ([dict objectForKey:@"content"]) {
                    jsonData = [NSString wcr_jsonWithDictionary:[dict objectForKey:@"content"]];
                }
                NSString* js = [NSString stringWithFormat:@"try{%@(%@);}catch(e){window.WCRDocSDK.log(e);}"
                                , callback
                                , jsonData];
                [self evaluateJavaScript:js completionHandler:nil];
            }];
        }
    }
}

- (void)onJsFuncError:(NSDictionary *)message{
    WCRCWLogInfo(@"onJsFuncError 改变造成webView reload %@",message);
    WCRError *error = [WCRError webCourseWareErrorWithErrorCode:WCRWCWErrorCodeJSError];
    if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
        [self.delegate courseWareDidLoad:self error:error];
    }
    
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    [self initParams];
    [self.webView reload];
}

- (void)onJsFuncScroll:(NSDictionary *)message{
    //这个方法的实现用scrollViewDidScroll代替掉啦。
    /*
    NSNumber *body = [message objectForKey:@"body"];
    if (body == nil) {
        WCRLogError(@"body 为空");
        return;
    }
    CGFloat offsetY = [body floatValue];
    CGFloat rate = 0;
    if (self.documentHeight != 0) {
        rate = offsetY/self.documentHeight;
        self.currentRate = rate;
    }
    
    if (body != nil && [self.webCourseDelegate respondsToSelector:@selector(webCourseWare:webViewDidScroll:)]) {
        [self.webCourseDelegate webCourseWare:self webViewDidScroll:rate];
    }
     */
}

- (void)onJsFuncHeightChange:(NSDictionary *)message{
    NSNumber *body = [message objectForKey:@"body"];
    if (body == nil) {
        WCRLogError(@"body 为空");
        return;
    }
    self.documentHeight = [body floatValue];
    if (!self.documentHeight) {
        WCRLogError(@"高度 为0");
        return;
    }
    if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWare:webViewHeightDidChange:)]) {
        [self.webCourseDelegate webCourseWare:self webViewHeightDidChange:self.documentHeight];
    }
    NSString* rateScript = [NSString stringWithFormat:@"window.slideAPI.scrollTo(%d);", (int)(self.currentRate * self.documentHeight)];
    if (self.isWebViewLoadSuccess) {
        [self evaluateJavaScript:rateScript completionHandler:nil];
    }else{
        [self.evaluateJaveScripts addObject:rateScript];
    }
}

- (void)onJsFuncWebLog:(NSDictionary *)message{
    if (message == nil) {
        WCRLogError(@"message 为空");
        return;
    }
    WCRCWLogInfo(@"onJsFuncWebLog:%@",message);
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    WCRCWLogInfo(@"Native To JS 交互 javaScriptString :%@",javaScriptString);
    if ([NSString wcr_isBlankString:javaScriptString]) {
        WCRCWLogError(@"javaScriptString 为空");
        return;
    }
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //取消scrollview手势缩放
    return nil;
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    WCRCWLogInfo(@"wkwebview开始加载:%@",self.url);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    WCRCWLogInfo(@"wkwebview加载完成:%@",self.url);
    self.webViewLoadSuccess = YES;
    [self disableDoubleTapScroll];
    //普通pdf课件等不走setUp回调的课件，在Webview回调加载完成时，同步翻页等操作
    [self syncJSAction];
    
    if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
        [self.delegate courseWareDidLoad:self error:nil];
    }
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    WCRCWLogInfo(@"wkwebview加载失败:%@",self.url);
    WCRError *wcrError = [WCRError webCourseWareErrorWithNSError:error];
    if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
        [self.delegate courseWareDidLoad:self error:wcrError];
    }
    //重试逻辑
    [self retryAfterRetryInterval:self.retryInterval];
}

- (void)retryAfterRetryInterval:(NSUInteger)interval{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        NSURL *url = [self getBackUpUrl];
        if (url != nil && ![NSString wcr_isBlankString:url.absoluteString] && ![NSString wcr_isBlankString:url.scheme]) {
            WCRCWLogInfo(@"retryAfterRetryInterval:%lu url:%@",(unsigned long)interval,url);
            if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
                [self.delegate courseWareWillLoad:self];
            }
            NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:urlRequest];
        }else{
            //相同间隔后，取下一条url进行重试
            [self retryAfterRetryInterval:interval];
        }
    });
    
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    WCRCWLogInfo(@"wkwebview内容开始返回:%@",self.url);
    //设置内容的宽高
    NSString *sizeJavascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no,shrink-to-fit=YES');document.getElementsByTagName('head')[0].appendChild(meta);";
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        sizeJavascript = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=%f, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);", self.view.bounds.size.width];
    }
    [webView evaluateJavaScript:sizeJavascript completionHandler:nil];

    if (self.isDocumentOpaque) {
        //设置课件t透明
        NSString *opaqueJavascript = @"document.body.style.backgroundColor='transparent';document.getElementsByTagName('html')[0].style.backgroundColor='transparent'";
        [webView evaluateJavaScript:opaqueJavascript completionHandler:nil];
    }
    //注入停用长按图片显示保存菜单,在课件中停用iOS11后的drag&drop功能
    NSString *dragJavascript = @"document.body.style.webkitTouchCallout='none';document.body.setAttribute('ondragstart','return false');";
    [webView evaluateJavaScript:dragJavascript completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (navigationResponse.isForMainFrame && [navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)navigationResponse.response).statusCode >= 400) {
        //mainFrame状态码400以上，算失败，取消加载，会自动走到失败的代理里面
        decisionHandler(WKNavigationResponsePolicyCancel);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    WCRCWLogInfo(@"wkwebview内容处理中断:%@",self.url);
    WCRError *error = [WCRError webCourseWareErrorWithErrorCode:WCRWCWErrorCodeProcessDidTerminate];
    if ([self.delegate respondsToSelector:@selector(courseWareDidLoad:error:)]) {
        [self.delegate courseWareDidLoad:self error:error];
    }
    
    if ([self.delegate respondsToSelector:@selector(courseWareWillLoad:)]) {
        [self.delegate courseWareWillLoad:self];
    }
    
    [self initParams];
    [webView reload];
}

-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.mediaPlaybackRequiresUserAction = false;
        if ([_webView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
        if([config respondsToSelector:@selector(setIgnoresViewportScaleLimits:)]) {
            if (@available(iOS 10.0, *)) {
                config.ignoresViewportScaleLimits = YES;
            }
        }
        if([config respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]) {
            if (@available(iOS 10.0, *)) {
                config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
            }
        } else if ([config respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
            if (@available(iOS 9.0, *)) {
                config.requiresUserActionForMediaPlayback = NO;
            }
        } else if ([config respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            config.mediaPlaybackRequiresUserAction = NO;
        }
        WCRCouerseWareWKWebviewMessageHandler *messageHandler = [[WCRCouerseWareWKWebviewMessageHandler alloc] init];
        messageHandler.delegate = self;
        [config.userContentController addScriptMessageHandler:messageHandler name:kWCRDocJSSDKScriptMessageHandler];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        
        _webView.scrollView.bounces = NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

/** 禁用单指双击滚动课件 */
- (void)disableDoubleTapScroll {
    // iterate over all subviews of the WKWebView's scrollView
    for (UIView *subview in self.webView.scrollView.subviews) {
        // iterate over recognizers of subview
        for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
            // check the recognizer is  a UITapGestureRecognizer
            if ([recognizer isKindOfClass:UITapGestureRecognizer.class]) {
                // cast the UIGestureRecognizer as UITapGestureRecognizer
                UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer*)recognizer;
                // check if it is a 1-finger double-tap
                if (tapRecognizer.numberOfTapsRequired == 2 && tapRecognizer.numberOfTouchesRequired == 1) {
                    [subview removeGestureRecognizer:recognizer];
                }
            }
        }
    }
}

#pragma mark- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentOffset = scrollView.contentOffset;
    if ([self.webCourseDelegate respondsToSelector:@selector(webCourseWare:webViewDidScroll:)]) {
        [self.webCourseDelegate webCourseWare:self webViewDidScroll:scrollView.contentOffset];
    }
}

-(UIView *)view{
    return self.webView;
}

-(NSMutableSet *)messagesSet{
    if (!_messagesSet) {
        _messagesSet = [NSMutableSet set];
    }
    return _messagesSet;
}

- (NSMutableArray *)messageBodys {
    if (!_messageBodys) {
        _messageBodys = [NSMutableArray array];
    }
    return _messageBodys;
}

- (NSMutableArray *)messageNames {
    if (!_messageNames) {
        _messageNames = [NSMutableArray array];
    }
    return _messageNames;
}
-(NSMutableArray *)evaluateJaveScripts {
    if (!_evaluateJaveScripts) {
        _evaluateJaveScripts = [NSMutableArray array];
    }
    return _evaluateJaveScripts;
}
@end
