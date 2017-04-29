//
//  KeyboardManager.h
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLKeyboardSource.h"

@interface WLKeyboardManager : NSObject

+ (instancetype) sharedManager;
- (NSArray<WLKeyboardSource *> *) keyboardLayouts;
- (NSArray<WLKeyboardSource *> *) enabledLayouts;
- (WLKeyboardSource *) currentKeyboardLayout;
- (void) selectLayoutWithID:(NSString *) layoutId;

@end
