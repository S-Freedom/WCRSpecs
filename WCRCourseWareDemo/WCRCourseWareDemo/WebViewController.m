//
//  WebViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "WebViewController.h"
#import <WCRCourseWare/WCRWebCourseWare.h>
#import <Masonry/Masonry.h>

@interface WebViewController ()
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
    self.urlTextField.text = @"https://ak-zby-oss-foreign.weclassroom.com/lesson/jenkins/light/198/1/787953/doc.html";
    
    self.jumpPage.text = @"2";
    self.jumpStep.text = @"0";
    
    self.scrollPage.text = @"1";
    self.scrollStep.text = @"0.5";
}

- (IBAction)createButtonTap:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    [self.courseWare loadURL:url];
    [self.courseWareView addSubview:self.courseWare.view];
    
    [self.courseWare.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseWareView.mas_left).offset(20);
        make.right.equalTo(self.courseWareView.mas_right).offset(-20);
        make.top.equalTo(self.courseWareView.mas_top).offset(20);
        make.bottom.equalTo(self.courseWareView.mas_bottom).offset(-20);
    }];
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

@end
