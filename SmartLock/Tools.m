//
//  Tools.m
//  SmartLock
//
//  Created by A1bert on 2017/3/1.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import "Tools.h"
#import <AVFoundation/AVFoundation.h>

@implementation Tools

/**
 语音提示

 @param promptString 被提示的字符串
 */
+ (void)voicePrompts:(nonnull NSString *)promptString {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!error) {
        AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:promptString];
        [speechSynthesizer speakUtterance:utterance];
    } else {
        NSLog(@"audio session set category error is %@", error);
    }
}


/**
 DES加密/解密方法

 @param context 加解密字符串
 @param key key字符串
 @param operation 加密/解密
 @return 加解密后的字符串
 */
+ (NSString *)cryptUseDES:(NSString *)context key:(NSString *)key operation:(CCOperation)operation {
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



static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation A1bertBase64

+(NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;

    char *characters = malloc(data.length * 3 / 2);

    if (characters == NULL)
        return nil;

    int end = (int)data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;

    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);

        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];

        index += 3;

        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }

    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;

}

+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = (int)data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }

        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;

    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

@end
