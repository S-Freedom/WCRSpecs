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

@property (nonatomic, strong) WCRWebCourseWare *courseWare;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.courseWare = [[WCRWebCourseWare alloc] init];
    self.courseWare.delegate = self;
    self.courseWare.webCourseDelegate = self;
    
    self.urlTextField.text = @"https://kjdsfz.cdn.aibeike.com/webkjdsfiles/893218e8ae1649a591e056e7c3bb42b9/index.html?id=2D1AB1D670E743AFBD1F36F053CA5D40&line=off&pageCount=14&devAutoChangePage=false&env=7&changePageTool=true&preview=flase";
//    self.urlTextField.text = @"https://ak-zby-oss-foreign.weclassroom.com/lesson/jenkins/light/198/1/787953/doc.html";
    
//    self.urlTextField.text = @"http://cloudclass-dev.oss-cn-beijing.aliyuncs.com/lesson/jenkins/113297/10018/pdfpage.html";
//    self.urlTextField.text = @"https://www.baidu.com";
    self.jumpPage.text = @"2";
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
- (IBAction)scrollButtonTap:(id)sender {
    [self.courseWare page:self.scrollPage.text.integerValue scrollToRate:self.scrollStep.text.integerValue];
}

-(void)courseWareWillLoad:(WCRCourseWare *)courseWare{
    
}

-(void)courseWareDidLoad:(WCRCourseWare *)courseWare error:(WCRError *)error{
    
}

//当前被滚动的比例
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewDidScroll:(CGFloat)rate{
    
}
//当前课件的高度
- (void)webCourseWare:(WCRWebCourseWare *)courseWare webViewHeightDidChange:(CGFloat)height{
    
}
//只会回调添加了监听的方法
- (void)webCourseWare:(WCRWebCourseWare *)courseWare receiveMessage:(NSString *)messageName withBody:(NSDictionary * _Nullable)messageBody{
    
}
//网页课件获取相关setup信息的回调
- (NSDictionary *)webCourseWareSetUpDocumentMessageDictionary:(WCRWebCourseWare *)courseWare{
    return nil;
}
//网页课件需要通过信道发送消息，并将信道消息回调给课件的回调
- (void)webCourseWare:(WCRWebCourseWare *)courseWare sendDocMessage:(NSString*)message withBody:(NSDictionary*)messageBody completion:(void (^ __nullable)(NSDictionary*))completion{
    
}

@end
