//
//  WCRWebCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WCRCourseWare/WCRCourseWare.h>

NS_ASSUME_NONNULL_BEGIN

//仿照UIKIT_EXTERN
#ifdef __cplusplus
#define WCR_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define WCR_EXTERN extern __attribute__((visibility ("default")))
#endif

WCR_EXTERN NSString * const kWCRWebCourseWareJSFuncSetUp;
WCR_EXTERN NSString * const kWCRWebCourseWareJSFuncSendMessage;
WCR_EXTERN NSString * const kWCRWebCourseWareJSErrorMessage;
WCR_EXTERN NSString * const kWCRWebCourseWareJSScrollMessage;
WCR_EXTERN NSString * const kWCRWebCourseWareJSHeightChangeMessage;

@class WCRWebCourseWare;
@protocol WCRWebCourseWareDelegate <NSObject>
@optional
//当前被滚动的比例
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewDidScroll:(CGFloat)rate;
//当前课件的高度
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewHeightDidChange:(CGFloat)height;
//只会回调添加了监听的方法
- (void)webCourseWare:(WCRWebCourseWare *)courseWare receiveMessage:(NSString *)messageName withBody:(NSDictionary * _Nullable)messageBody;
//网页课件获取相关setup信息的回调
- (NSDictionary *)webCourseWareSetUpDocumentMessageDictionary:(WCRWebCourseWare *)courseWare;
//网页课件需要通过信道发送消息，并将信道消息回调给课件的回调
- (void)webCourseWare:(WCRWebCourseWare *)courseWare sendDocMessage:(NSString*)message withBody:(NSDictionary*)messageBody completion:(void (^ __nullable)(NSDictionary*))completion;
@end

@interface WCRWebCourseWare : WCRCourseWare
@property (nonatomic, weak) id<WCRWebCourseWareDelegate>webCourseDelegate;
@property (nonatomic, assign, readonly) CGFloat currentRate;
@property (nonatomic, assign, readonly) CGFloat documentHeight;
- (WCRError * _Nullable)loadURL:(NSURL *)url;
- (void)goToPage:(NSInteger)page step:(NSInteger)step;
- (void)page:(NSInteger)page scrollToRate:(CGFloat)rate;
- (void)mouseClick:(CGRect)click;
- (void)registerMessageWithMessageName:(NSString *)messageName;
- (void)unregisterMessageWithMessageName:(NSString *)messageName;
- (void)unregisterAllMessages;
- (NSArray *)allRegisterMessages;
- (void)sendMessage:(NSString *)messageName withBody:(NSDictionary *)messageBody completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
