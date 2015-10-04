//
//  main.m
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 28.09.15.
//  Copyright © 2015 Wolfgang Lutz. All rights reserved.
//

#import "WLCommandLineInterpreter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // Create NSArray from Arguments
        NSMutableArray<NSString *> * arguments = [[NSMutableArray alloc] initWithCapacity: argc];
        if(arguments)
        {
            NSInteger count = 0;
            while( count++ < argc -1 )
            {
                [arguments addObject: [NSString stringWithFormat: @"%s", argv[count]]];
            }
        }
        
        [WLCommandLineInterpreter interpretArgumentsFromArray:arguments];
        [WLCommandLineInterpreter interpretArgumentsFromArray:@[@"version"]];
    }
    return 0;
}