//
//  WebViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "WebViewController.h"
#import <WCRCourseWareSDK/WCRWebCourseWare.h>
#import <Masonry/Masonry.h>

@interface WebViewController ()<WCRCourseWareDelegate, WCRWebCourseWareDelegate>
@property (weak, nonatomic) IBOutlet UIView *courseWareView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *jumpPage;
@property (weak, nonatomic) IBOutlet UITextField *jumpStep;
@property (weak, nonatomic) IBOutlet UITextField *scrollPage;
@property (weak, nonatomic) IBOutlet UITextField *scrollStep;

@property (assign, nonatomic) NSUInteger currentPage;

@property (nonatomic, strong) WCRWebCourseWare *courseWare;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    // Do any additional setup after loading the view from its nib.
    self.courseWare = [[WCRWebCourseWare alloc] init];
    self.courseWare.delegate = self;
    self.courseWare.webCourseDelegate = self;
    
//    self.urlTextField.text = @"https://kjdsfz.cdn.aibeike.com/webkjdsfiles/893218e8ae1649a591e056e7c3bb42b9/index.html?id=2D1AB1D670E743AFBD1F36F053CA5D40&line=off&pageCount=14&devAutoChangePage=false&env=7&changePageTool=true&preview=flase";
//    self.urlTextField.text = @"https://ak-zby-oss-foreign.weclassroom.com/lesson/jenkins/light/198/1/787953/doc.html";
    
//    self.urlTextField.text = @"http://cloudclass-dev.oss-cn-beijing.aliyuncs.com/lesson/jenkins/113297/10018/pdfpage.html";
//    self.urlTextField.text = @"https://www.baidu.com";
    self.urlTextField.text = @"https://zby-oss-foreign.weclassroom.com/lesson/jenkins/288809/2194101/doc.html";
//    self.urlTextField.text = @"https://games.vipx.com/live-quiz/zs/g1L36/index.html";
    self.jumpPage.text = @"21";
    self.jumpStep.text = @"0";
    
    self.scrollPage.text = @"1";
    self.scrollStep.text = @"0.5";
}

- (IBAction)createButtonTap:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    [self.courseWareView addSubview:self.courseWare.view];
    
    [self.courseWare.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseWareView.mas_left).offset(20);
        make.right.equalTo(self.courseWareView.mas_right).offset(-20);
        make.top.equalTo(self.courseWareView.mas_top).offset(20);
        make.bottom.equalTo(self.courseWareView.mas_bottom).offset(-20);
    }];
    
    [self.courseWare loadURL:url];
}
- (IBAction)destoryButtonTap:(id)sender {
    [self.courseWare.view removeFromSuperview];
}
- (IBAction)jumpButtonTap:(id)sender {
    [self.courseWare goToPage:self.jumpPage.text.integerValue step:self.jumpStep.text.integerValue];
}
- (IBAction)nextPage:(id)sender {
     [self.courseWare goToPage:++self.currentPage step:0];
}
- (IBAction)lastPage:(id)sender {
    [self.courseWare goToPage:--self.currentPage step:0];
}
- (IBAction)scrollButtonTap:(id)sender {
    [self.courseWare page:self.scrollPage.text.integerValue scrollToRate:self.scrollStep.text.integerValue];
}
- (IBAction)start:(id)sender {
    //开始答题
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"209ca4710fc3e8eb86eac1dca00a5195", @"docID", @"21", @"tid", @"17", @"timeout", @"0", @"type", nil];
//    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:self.docID, @"docID", item.tid, @"tid", item.timeout, @"timeout", item.type, @"type", nil];
    [self.courseWare sendMessage:@"start.test" withBody:body completionHandler:nil];
}

- (IBAction)stop:(id)sender {
    //开始答题
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:@"209ca4710fc3e8eb86eac1dca00a5195", @"docID", @"21", @"tid", @"0", @"type", nil];
    //    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:self.docID, @"docID", item.tid, @"tid", item.timeout, @"timeout", item.type, @"type", nil];
    [self.courseWare sendMessage:@"stop.test" withBody:body completionHandler:nil];
}

-(void)courseWareWillLoad:(WCRCourseWare *)courseWare{
    
}

-(void)courseWareDidLoad:(WCRCourseWare *)courseWare error:(WCRError *)error{
    
}

//当前被滚动的比例
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewDidScroll:(CGPoint)offsetPoint {
    
}
//当前课件的高度
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewHeightDidChange:(CGFloat)height{
    
}
//只会回调添加了监听的方法
- (void)webCourseWare:(WCRWebCourseWare *)courseWare receiveMessage:(NSString *)messageName withBody:(NSDictionary * _Nullable)messageBody{
    
}
//网页课件获取相关setup信息的回调
- (NSDictionary *)webCourseWareSetUpDocumentMessageDictionary:(WCRWebCourseWare *)courseWare{
    
//     VIPX事例
    NSDictionary* callbackContent = @{
    @"error": @0,
    @"description": @"",
    @"isTeacher" : @false,
    @"docId": @"209ca4710fc3e8eb86eac1dca00a5195",
    @"classId": @"76",
    @"userId": @"201705",
    @"type":@"simple",
    @"token":@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiMiIsInN1YiI6NDQ0LCJpc3MiOiJodHRwOlwvXC9kZXYtYXBpLndlY2xhc3Nyb29tLmNvbVwvdXNlclwvbG9naW4iLCJpYXQiOjE0OTQ0ODExMDAsImV4cCI6MTQ5NzA3MzEwMCwibmJmIjoxNDk0NDgxMTAwLCJqdGkiOiJhYWY0N2ZiZWNjZmUwNzVhYWIxZDRkNzhiNGEwNzI4ZSJ9.WmRoSgIYnKmbDygd_epWVvGqLQgCRQQ5fdD9I3-wABY",
    @"version":@"1.1.4",
    @"isReplay":@0
    };
//     */
//    NSDictionary* callbackContent = nil;
    NSAssert(callbackContent != nil, @"填写这个课件的setUp字典");
    return callbackContent;
    
}
//网页课件需要通过信道发送消息，并将信道消息回调给课件的回调
- (void)webCourseWare:(WCRWebCourseWare *)courseWare sendDocMessage:(NSString*)message withBody:(NSDictionary*)messageBody completion:(void (^ __nullable)(NSDictionary*))completion{
    
}

@end
