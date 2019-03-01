//
//  MainViewController.m
//  WCRCourseWareDemo
//
//  Created by 欧阳铨 on 2019/2/28.
//  Copyright © 2019 com.100tal. All rights reserved.
//

#import "MainViewController.h"
#import "ViewViewController.h"
#import "ImageViewController.h"
#import "WebViewController.h"
#import "AVViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)viewButtonTap:(id)sender {
    ViewViewController *vc = [[ViewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)imageButtonTap:(id)sender {
    ImageViewController *vc = [[ImageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)webButtonTap:(id)sender {
    WebViewController *vc = [[WebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)avButtonTap:(id)sender {
    AVViewController *vc = [[AVViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
