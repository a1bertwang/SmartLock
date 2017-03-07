//
//  Tools.h
//  SmartLock
//
//  Created by A1bert on 2017/3/1.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN
@interface Tools : NSObject

+ (void)voicePrompts:(NSString *)promptString;
+ (NSString *)cryptUseDES:(NSString *)context key:(NSString *)key operation:(CCOperation)operation;

@end
NS_ASSUME_NONNULL_END

@interface A1bertBase64 : NSObject

+(int)char2Int:(char)c;
@end
