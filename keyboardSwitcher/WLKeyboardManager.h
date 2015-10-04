//
//  KeyboardManager.h
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLKeyboardManager : NSObject

+ (NSDictionary *) keyboardLayouts;
+ (NSString *) currentKeyboardLayout;
+ (void) selectLayoutWithID:(NSString *) layoutId;

@end
