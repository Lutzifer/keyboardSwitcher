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

typedef BOOL(^SourcePredicateBlock)(WLKeyboardSource * source);

@implementation WLKeyboardManager

+ (instancetype) sharedManager {
    static WLKeyboardManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (NSArray<WLKeyboardSource *> *) keyboardLayouts {
    return [self sourceList];
}

- (NSArray<WLKeyboardSource *> *) enabledLayouts {
    return [[self sourceList] filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(WLKeyboardSource *  _Nullable source, NSDictionary<NSString *,id> * _Nullable bindings) {
                return source.enabled;
            }]
    ];
}

- (WLKeyboardSource *) currentKeyboardLayout {
    return [[WLKeyboardSource alloc] initWithSource:TISCopyCurrentKeyboardInputSource()];
}

- (void) selectLayoutWithID:(NSString *) layoutId {
    NSArray<WLKeyboardSource *> * sources = [self keyboardSourcesForDictionary:
                        @{ (__bridge NSString*)kTISPropertyInputSourceID : layoutId }
                        ];
    

    if (sources.count == 0) {
        NSString * shortLayoutId = [layoutId componentsSeparatedByString:@"."].lastObject;
        sources =  [self keyboardSourcesForDictionary:
                        @{ (__bridge NSString*)kTISPropertyLocalizedName : shortLayoutId }
                    ];
    }

    OSStatus status = TISSelectInputSource(sources[0].source);
    
    if (status != noErr) {
        DLog(@"Failed to set the layout \"%@\".", layoutId);
    };
}

#pragma MARK Private

- (NSArray<WLKeyboardSource *> *) sourceList {
    NSArray * keyboardLayoutInputSources = [self keyboardSourcesForDictionary:
                                        @{ (NSString *)kTISPropertyInputSourceType : (NSString *)kTISTypeKeyboardLayout }
                                        ];
    
    NSArray * inputModeInputSources = [self keyboardSourcesForDictionary:
                                        @{ (NSString *)kTISPropertyInputSourceType : (NSString *)kTISTypeKeyboardInputMode }
                                        ];
    
    return [keyboardLayoutInputSources arrayByAddingObjectsFromArray:inputModeInputSources];
}

- (NSArray<WLKeyboardSource *> *) keyboardSourcesForDictionary:(NSDictionary *) dictionary {
    NSMutableArray<WLKeyboardSource *> * sources = [NSMutableArray<WLKeyboardSource *> new];
    NSArray * sourceList = (__bridge NSArray*)(TISCreateInputSourceList ((__bridge CFDictionaryRef)(dictionary),true));
    
    [sourceList enumerateObjectsUsingBlock:^(id  _Nonnull sourceObject, NSUInteger idx, BOOL * _Nonnull stop) {
        [sources addObject:[[WLKeyboardSource alloc] initWithSource:(__bridge TISInputSourceRef)sourceObject]];
    }];
    
    return sources;
}

@end
