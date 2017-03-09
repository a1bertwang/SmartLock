//
//  ViewController.m
//  SmartLock
//
//  Created by A1bert on 2017/2/28.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import "ViewController.h"
#import "Tools.h"

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *str = @"abcde001011";
    NSString *res1 = [Tools cryptUseDES:str key:@"" operation:kCCEncrypt];
    PBLog(@"%@",res1);
    PBLog(@"%@", [Tools cryptUseDES:res1 key:@"" operation:kCCDecrypt]);
    [self performSegueWithIdentifier:@"qqq" sender:self];
}

@end



































































