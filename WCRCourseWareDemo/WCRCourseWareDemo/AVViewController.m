//
//  AVViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "AVViewController.h"
#import <WCRCourseWare/WCRAVCourseWare.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface AVViewController ()<WCRAVCourseWareDelegate,WCRCourseWareDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIView *courseWareView;
@property (strong, nonatomic) WCRAVCourseWare *courseWare;
@end

@implementation AVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.courseWare = [[WCRAVCourseWare alloc] initWithScalingMode:WCRAVCourseWareScalingModeAspectFit];
    self.urlTextField.text = @"https://mediacourseware.weclassroom.com/files/0e562c7a-cc04-430f-8d2d-e24a6452b202.mp4";
    
    @weakify(self);
    [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self);
        self.progressSlider.value = self.courseWare.currentTime / self.courseWare.totalTime;
    }];
    
    self.courseWare.delegate = self;
    self.courseWare.avCourseWareDelegate = self;
}
- (IBAction)createButtonTap:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    [self.courseWare loadURL:url withType:WCRAVCourseWareTypeVideo];
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
- (IBAction)startButtonTap:(id)sender {
    [self.courseWare play];
}
- (IBAction)pauseButtonTap:(id)sender {
    [self.courseWare pause];
}
- (IBAction)stopButtonTap:(id)sender {
    [self.courseWare stop];
}
- (IBAction)progressChange:(id)sender {
    [self.courseWare seekToTime:((UISlider *)sender).value * self.courseWare.totalTime];
}

-(void)avCourseWare:(WCRAVCourseWare *)courseWare statusChange:(WCRAVCourseWarePlayStatus)status{
    NSLog(@"status: %lu",(unsigned long)status);
}

-(void)courseWareWillLoad:(WCRCourseWare *)courseWare{
    NSLog(@"courseWare will load");
}

-(void)courseWareDidLoad:(WCRCourseWare *)courseWare error:(WCRError *)error{
    NSLog(@"courseWare did load %@",error);
}

@end
