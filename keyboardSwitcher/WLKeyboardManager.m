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

typedef BOOL(^SourcePredicateBlock)(TISInputSourceRef source);

@implementation WLKeyboardManager

+ (NSDictionary *) keyboardLayouts {
    return [self sourcesWithPredicate:^BOOL(TISInputSourceRef source) {
        return YES;
    }];
}

+ (NSDictionary *) enabledLayouts {
    return [self sourcesWithPredicate:^BOOL(TISInputSourceRef source) {
        return [self isSourceEnabled:source];
    }];
}

+ (NSDictionary *) sourcesWithPredicate:(SourcePredicateBlock)predicateBlock {
    CFArrayRef sourceList = [[self class] sourceList];
    NSMutableDictionary *layouts = [NSMutableDictionary dictionary];
    for (int i = 0; i < CFArrayGetCount(sourceList); ++i) {
        TISInputSourceRef source = (TISInputSourceRef)(CFArrayGetValueAtIndex(sourceList, i));
        if (!predicateBlock(source)) continue;

        [self appendSource:source toDict:layouts];
    }

    return layouts;
}

+ (CFArrayRef) sourceList {
    NSDictionary *ref = @{ (NSString *)kTISPropertyInputSourceType : (NSString *)kTISTypeKeyboardLayout };
    CFArrayRef sourceList = (TISCreateInputSourceList ((__bridge CFDictionaryRef)(ref),true));
    return sourceList;
}

+ (void) appendSource:(TISInputSourceRef)source toDict:(NSMutableDictionary *)layouts {
    NSString* sourceID = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyInputSourceID));
    NSString* localizedName = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyLocalizedName));
    [layouts setObject:sourceID forKey:localizedName];
}

+ (BOOL) isSourceEnabled:(TISInputSourceRef)source {
    NSNumber *enabled = (__bridge NSNumber *)(TISGetInputSourceProperty(source, kTISPropertyInputSourceIsEnabled));
    return enabled.boolValue;
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
