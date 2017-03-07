//
//  ViewController.m
//  SmartLock
//
//  Created by A1bert on 2017/2/28.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Tools.h"
#import <CommonCrypto/CommonCryptor.h>
//#import "GTMBase64.h"

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
//    [Tools voicePrompts:@"红红火火恍恍惚惚"];
    NSString *str = @"abcde001011";
    NSString *res = [self encryptUseDES:str key:@""];
    NSLog(@"%@",res);
    NSLog(@"%@",[self decryptUseDES:res key:@""]);
    NSString *res1 = [self cryptUseDES:str key:@"" operation:kCCEncrypt];
    NSLog(@"%@",res1);
    NSLog(@"%@", [self cryptUseDES:res1 key:@"" operation:kCCDecrypt]);

    [self performSegueWithIdentifier:@"qqq" sender:self];
}

- (NSString *)encryptUseDES:(NSString *)context key:(NSString *)key {
    NSData *contextData = [context dataUsingEncoding:NSASCIIStringEncoding];
    size_t dataOutAvailable = contextData.length + kCCKeySizeDES;
    void *dataOut = malloc(dataOutAvailable);
    size_t dataOutMoved = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES, NULL, contextData.bytes, contextData.length, dataOut, dataOutAvailable, &dataOutMoved);
    if (status == kCCSuccess) {
        contextData = [NSData dataWithBytes:dataOut length:dataOutMoved];
        free(dataOut);
        return [contextData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    } else {
        return nil;
    }
}

- (NSString *)decryptUseDES:(NSString *)context key:(NSString *)key {
    NSData *contextData = [[NSData alloc] initWithBase64EncodedString:context options:NSDataBase64DecodingIgnoreUnknownCharacters];
    size_t dataOutAvailable = contextData.length + kCCKeySizeDES;
    void *dataOut = malloc(dataOutAvailable);
    size_t dataOutMoved = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES, NULL, contextData.bytes, contextData.length, dataOut, dataOutAvailable, &dataOutMoved);
    if (status == kCCSuccess) {
        contextData = [NSData dataWithBytes:dataOut length:dataOutMoved];
        free(dataOut);
        return [[NSString alloc] initWithData:contextData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSString *)cryptUseDES:(NSString *)context key:(NSString *)key operation:(CCOperation)operation {
    NSData *contextData = nil;
    switch (operation) {
        case kCCEncrypt: {
            contextData = [context dataUsingEncoding:NSASCIIStringEncoding];
        }
            break;
        case kCCDecrypt: {
            contextData = [[NSData alloc] initWithBase64EncodedString:context options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
            break;
    }

    size_t dataOutAvailable = contextData.length + kCCKeySizeDES;
    void *dataOut = malloc(dataOutAvailable);
    size_t dataOutMoved = 0;
    CCCryptorStatus status = CCCrypt(operation, kCCAlgorithmDES, kCCOptionPKCS7Padding, key.UTF8String, kCCKeySizeDES, NULL, contextData.bytes, contextData.length, dataOut, dataOutAvailable, &dataOutMoved);

    if (status == kCCSuccess) {
        switch (operation) {
            case kCCEncrypt: {
                contextData = [NSData dataWithBytes:dataOut length:dataOutMoved];
                free(dataOut);
                return [contextData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            }
                break;
            case kCCDecrypt: {
                contextData = [NSData dataWithBytes:dataOut length:dataOutMoved];
                free(dataOut);
                return [[NSString alloc] initWithData:contextData encoding:NSUTF8StringEncoding];
            }
                break;
        }
    }

    return nil;
}

@end
