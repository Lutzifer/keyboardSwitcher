//
//  KeyboardManager.m
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import "DLog.h"
#import "WLKeyboardManager.h"
#import <Foundation/Foundation.h>
@import Carbon;

@implementation WLKeyboardManager

+ (NSDictionary *) keyboardLayouts {
    NSDictionary *ref = @{ (NSString *)kTISPropertyInputSourceType : (NSString *)kTISTypeKeyboardLayout };
    CFArrayRef sourceList = TISCreateInputSourceList ((__bridge CFDictionaryRef)(ref),true);
    
    NSMutableDictionary * layouts = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < CFArrayGetCount(sourceList); ++i) {
        TISInputSourceRef source = (TISInputSourceRef)(CFArrayGetValueAtIndex(sourceList, i));
        NSString* sourceID = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyInputSourceID));
        NSString* localizedName = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyLocalizedName));
        [layouts setObject:sourceID forKey:localizedName];
    }
    
    return layouts;
}

+ (NSString *) currentKeyboardLayout {
    return [NSString stringWithFormat:@"%@", TISGetInputSourceProperty(TISCopyCurrentKeyboardInputSource(), kTISPropertyLocalizedName)];
}

+ (void) selectLayoutWithID:(NSString *) layoutId {
    NSArray* sources = CFBridgingRelease(TISCreateInputSourceList((__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyInputSourceID : layoutId }, FALSE));

    if (sources.count == 0) {
        NSString * shortLayoutId = [layoutId componentsSeparatedByString:@"."].lastObject;
        sources = CFBridgingRelease(TISCreateInputSourceList((__bridge CFDictionaryRef)@{ (__bridge NSString*)kTISPropertyLocalizedName : shortLayoutId }, FALSE));
    }

    TISInputSourceRef source = (__bridge TISInputSourceRef)sources[0];
    OSStatus status = TISSelectInputSource(source);
    if (status != noErr) {
        DLog(@"Failed to set the layout \"%@\".", layoutId);
    };
}

@end
