//
//  commandLineInterpreter.m
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import "DLog.h"
#import "Version.h"
#import "WLCommandLineInterpreter.h"
#import "WLKeyboardManager.h"

@implementation WLCommandLineInterpreter

+ (void) interpretArgumentsFromArray: (NSArray<NSString *> *) argumentArray {
    
    switch ([argumentArray count]) {
        case 0:
            [[self class] printHelp];
            break;
        case 1:
            [[self class] handleUnaryCommand:[argumentArray[0] lowercaseString]];
            break;
        case 2:
            [[self class] handleBinaryCommand:argumentArray];
            break;
        default:
            DLog(@"Error: Unknown Command");
            [[self class] printCommands];
            break;
    }
}

+ (void) printHelp {
    DLog(@"A Tool to set the current KeyboardLayout");
    [[self class] printCommands];
}

+ (void) printCommands {
    DLog(@"Available Commands:");
    DLog(@"\t - list: list the available layouts");
    DLog(@"\t - select \"<layout>\": sets the layout");
    DLog(@"\t - get: get the current layout");
    DLog(@"\t - version: print the version of KeyboardSwitcher");
}

+ (void) printCommandErrorForCommand:(NSString *) command {
    DLog(@"Error: Unknown Command \"%@\"", command);
    [[self class] printCommands];
}

+ (void) handleUnaryCommand:(NSString *) mainCommand {
    if([mainCommand isEqualToString:@"list"]) {
        [[self class] listAvailableLayouts];
    } else if([mainCommand isEqualToString:@"get"]) {
        DLog(@"%@", [WLKeyboardManager currentKeyboardLayout]);
    } else if([mainCommand isEqualToString:@"version"]) {
        DLog(@"Current Version: %@", @(KSVersion));
    } else {
        [[self class] printCommandErrorForCommand:mainCommand];
    }
}

+ (void) handleBinaryCommand:(NSArray *) argumentArray {
    NSString * mainCommand = [argumentArray[0] lowercaseString];
    
    if([mainCommand isEqualToString:@"select"]) {
        NSString * layoutNameToSelect = argumentArray[1];
        NSDictionary<NSString *, NSString *> * layoutDictionary = [WLKeyboardManager keyboardLayouts];

        // Test if layout exists
        NSString * layoutIdToSelect = layoutDictionary[layoutNameToSelect];
        if(layoutIdToSelect) {
            [WLKeyboardManager selectLayoutWithID:layoutIdToSelect];
            
            if(![[WLKeyboardManager currentKeyboardLayout] isEqualToString:layoutNameToSelect]) {
                DLog(@"Layout \"%@\" known, but could not be set: Please add the layout in System Preferences.app > Keyboard > Input Sources to fix this.", layoutIdToSelect);
            }
            
        } else {
            DLog(@"Unknown Layout \"%@\": Did you forget to put the identifier in quotation marks?", layoutIdToSelect);
            [[self class] listAvailableLayouts];
        }
    } else {
        [[self class] printCommandErrorForCommand:mainCommand];
    }
}

+ (void) listAvailableLayouts {
    NSArray<NSString *> * layouts = [[[WLKeyboardManager keyboardLayouts] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    DLog(@"Available Layouts:");
    [layouts enumerateObjectsUsingBlock:^(NSString * _Nonnull layout, NSUInteger idx, BOOL * _Nonnull stop) {
        DLog(@"\t%@", layout);
    }];
}

@end
