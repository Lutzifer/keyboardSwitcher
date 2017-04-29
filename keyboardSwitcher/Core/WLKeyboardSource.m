//
//  WLKeyboardSource.m
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 07.10.16.
//  Copyright © 2016 number42. All rights reserved.
//

#import "WLKeyboardSource.h"

@implementation WLKeyboardSource

- (instancetype)initWithSource:(TISInputSourceRef) source {
    self = [super init];
    if (self) {
        _source = source;
    }
    return self;
}

- (NSString *) localizedName {
    return [self getStringforProperty:kTISPropertyLocalizedName];
}

- (NSString *) inputSourceID {
    return [self getStringforProperty:kTISPropertyInputSourceID];
}

- (BOOL) enabled {
    return [self getBoolforProperty:kTISPropertyInputSourceIsEnabled];
}


- (NSString *) getStringforProperty: (CFStringRef) property {
    return (__bridge NSString *)(TISGetInputSourceProperty(self.source, property));
}

- (BOOL) getBoolforProperty: (CFStringRef) property {
    NSNumber *enabled = (__bridge NSNumber *)(TISGetInputSourceProperty(self.source, property));
    return enabled.boolValue;
}


@end
