//
//  PBPrivateFuncation.h
//  SmartLock
//
//  Created by A1bert on 2017/3/9.
//  Copyright © 2017年 PlumBlossom. All rights reserved.
//

#ifndef PBPrivateFuncation_h
#define PBPrivateFuncation_h

#ifdef  DEBUG
//A better version of NSLog
#define PBLog(format, ...)  do {                                            \
fprintf(stderr, "------------------------------------------------------------------------------------\n");                          \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "\n<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
fprintf(stderr, "------------------------------------------------------------------------------------\n");                          \
} while (0)
#else
//A better version of NSLog
#define PBLog(format, ...)  do {} while (0)
#endif

#endif /* PBPrivateFuncation_h */
