//
//  AppDelegate.m
//  cuImageLauncher
//
//  Created by Lizhen Hu on 08/02/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Check whether the main application is already running.
    BOOL isRunning = NO;
    NSString *key = @"MainBundleIdentifier";
    NSString *mainBundleIdentifier = (NSString *)[NSBundle mainBundle].infoDictionary[key];
    NSArray *runningApplications = [NSWorkspace sharedWorkspace].runningApplications;
    for (NSRunningApplication *app in runningApplications) {
        if ([app.bundleIdentifier isEqualToString:mainBundleIdentifier]) {
            isRunning = true;
            break;
        }
    }
    
    if (!isRunning) {
        // Get absolute path of the main application.
        NSMutableArray *pathComponents = (NSMutableArray *)[[NSBundle mainBundle].bundlePath componentsSeparatedByString:@"/"];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        NSString *appPath = [pathComponents componentsJoinedByString:@"/"];
        
        // Launch the main application.
        [[NSWorkspace sharedWorkspace] launchApplication:appPath];
    }
    
    // Terminate the launcher.
    [NSApp terminate:self];
}

@end
