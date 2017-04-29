//
//  DLog.h
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#if __has_feature(objc_arc)
#define DLog(format, ...) CFShow((__bridge CFStringRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
#define DLog(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);
#endif