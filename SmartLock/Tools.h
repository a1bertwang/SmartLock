//
//  Tools.h
//  SmartLock
//
//  Created by A1bert on 2017/3/1.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (void)voicePrompts:(nonnull NSString *)promptString;

@end

@interface A1bertBase64 : NSObject
+(int)char2Int:(char)c;
@end
