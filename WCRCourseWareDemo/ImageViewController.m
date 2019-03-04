//
//  ImageViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "ImageViewController.h"
#import <WCRCourseWareSDK/WCRImageCourseWare.h>
#import <Masonry/Masonry.h>

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIView *courseWareView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) WCRImageCourseWare *courseWare;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.urlTextField.text = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551333702362&di=af5a1e9a650537879185570862d68178&imgtype=0&src=http%3A%2F%2Fpic164.nipic.com%2Ffile%2F20180514%2F24821412_152755333000_2.jpg";
}
- (IBAction)createButtonTap:(id)sender {
    self.courseWare = [[WCRImageCourseWare alloc] init];
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    [self.courseWare loadImageWithURL:url];
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


@end
