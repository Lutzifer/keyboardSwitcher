//
//  commandLineInterpreter.h
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 04.10.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLCommandLineInterpreter : NSObject

+ (void) interpretArgumentsFromArray: (NSArray<NSString *> *) argumentArray;
@end
