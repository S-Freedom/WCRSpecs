//
//  WCRWebCourseWare.h
//  WCRLiveCore
//
//  Created by 欧阳铨 on 2018/10/22.
//  Copyright © 2018 com.100tal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WCRCourseWareSDK/WCRCourseWare.h>

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

/**
 当前课件被滚动的比例

 @param courseWare 被滚动的课件
 @param offsetPoint 滚动位置
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewDidScroll:(CGPoint)offsetPoint;

/**
 当前课件高度或高度变化

 @param courseWare 高度变化课件
 @param height 课件的高度
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewHeightDidChange:(CGFloat)height;

/**
 当前课件大小发生改变

 @param courseWare 课件
 @param size 课件size
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewSizeDidChange:(CGSize)size;

/**
 课件js方法回调

 @param courseWare 课件
 @param messageName 回调方法名
 @param messageBody 回调消息体
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare receiveMessage:(NSString *)messageName withBody:(NSDictionary * _Nullable)messageBody;

/**
 课件获取setUp信息

 @param courseWare 需要获取信息的课件
 @return 需要返回课件需要的信息字典
 */
- (NSDictionary *)webCourseWareSetUpDocumentMessageDictionary:(WCRWebCourseWare *)courseWare;

/**
 课件通过信道发送消息，并在block中将信道回复的消息送回课件

 @param courseWare 需要发送消息的课件
 @param message 消息名
 @param messageBody 消息体
 @param completion 信道发送消息后的回复消息
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare sendDocMessage:(NSString*)message withBody:(NSDictionary*)messageBody completion:(void (^ __nullable)(NSDictionary*))completion;

/**
 课件当前页面改变

 @param courseWare self
 @param currentPageIndex 当前页面
 @param totalPageCount 总页面数
 */
- (void)webCourseWare:(WCRWebCourseWare *)courseWare currentPageIndexChanged:(NSUInteger)currentPageIndex totalPageCount:(NSUInteger)totalPageCount;

@end

@interface WCRWebCourseWare : WCRCourseWare

/**
 网页课件代理
 */
@property (nonatomic, weak) id<WCRWebCourseWareDelegate>webCourseDelegate;

/**
 当前滚动偏移量
 */
@property (nonatomic, assign, readonly) CGPoint currentOffset;

/**
 当前课件高度
 */
@property (nonatomic, assign, readonly) CGFloat documentHeight;

/**
 使用允许用户主动滚动（默认为YES）
 */
@property (nonatomic, assign, getter=isUserScrollEnable) BOOL userScrollEnable;

/**
 设置课件是否透明（默认为NO）,只有在-courseWareWillLoad:回调之前设置有效
 */
@property (nonatomic, assign, getter=isDocumentOpaque) BOOL documentOpaque;

@property (nonatomic, assign, readonly) NSInteger currentPageReal;//实际page index
@property (nonatomic, assign, readonly) NSInteger currentStepReal;//实际step index

/**
 当前页数
 */
@property (nonatomic, assign) NSUInteger currentPageIndex;

/**
 总页数
 */
@property (nonatomic, assign) NSUInteger totalPageCount;

/**
 加载课件

 @param url 课件url
 @return 方法是否执行成功 @see -courseWareWillLoad:; @see -courseWareDidLoad:error:;
 */
- (WCRError * _Nullable)loadURL:(NSURL *)url;

/**
 课件翻页

 @param page 页码
 @param step 步数
 */
- (void)goToPage:(NSInteger)page step:(NSInteger)step;

/**
 课件滚动

 @param page 页码
 @param rate 滚动比例
 */
- (void)page:(NSInteger)page scrollToRate:(CGFloat)rate;

/**
 模拟鼠标点击

 @param click 点击的位置
 */
- (void)mouseClick:(CGRect)click;

/**
 注册消息监听

 @param messageName 消息名字
 */
- (void)registerMessageWithMessageName:(NSString *)messageName;

/**
 反注册消息监听
 
 @param messageName 消息名字
 */
- (void)unregisterMessageWithMessageName:(NSString *)messageName;

/**
 反注册所有消息监听
 
 */
- (void)unregisterAllMessages;

/**
 返回所有注册的消息

 @return 注册消息名字数组
 */
- (NSArray *)allRegisterMessages;

/**
 发送自定义消息到课件

 @param messageName 消息名字
 @param messageBody 消息体
 @param completionHandler 消息回调block
 */
- (void)sendMessage:(NSString *)messageName withBody:(NSDictionary * _Nullable)messageBody completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
