//
//  WLKeyboardSource.h
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 07.10.16.
//  Copyright © 2016 number42. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Carbon;

@interface WLKeyboardSource : NSObject

- (instancetype)initWithSource:(TISInputSourceRef) source;

@property (strong, readonly) NSString* localizedName;
@property (strong, readonly) NSString* inputSourceID;
@property (readonly) BOOL enabled;
@property (readonly) TISInputSourceRef source;
@end
