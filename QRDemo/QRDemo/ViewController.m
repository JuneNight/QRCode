//
//  ViewController.m
//  QRDemo
//
//  Created by 张涛 on 17/5/23.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ViewController.h"
#import "JYQrController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickAction:(id)sender {
    JYQrController *vc = [[JYQrController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
