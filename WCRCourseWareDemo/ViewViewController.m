//
//  ViewViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "ViewViewController.h"
#import <WCRCourseWareSDK/WCRViewCourseWare.h>
#import <Masonry/Masonry.h>

@interface ViewViewController ()
@property (weak, nonatomic) IBOutlet UIView *courseWareView;
@property (strong, nonatomic) WCRViewCourseWare *courseWare;

@end

@implementation ViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createButtonTap:(id)sender {
    self.courseWare = [[WCRViewCourseWare alloc] init];
    [self.courseWare createView:[UIColor redColor]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
