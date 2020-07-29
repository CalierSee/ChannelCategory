//
//  ViewController.m
//  Demo
//
//  Created by Macbook Pro on 2020/7/28.
//  Copyright © 2020 Category. All rights reserved.
//

#import "ViewController.h"
#import "ALCHomeChannelViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ALCHomeChannelViewController * vc = [[ALCHomeChannelViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
