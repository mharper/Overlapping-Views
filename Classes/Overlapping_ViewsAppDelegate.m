//
//  Overlapping_ViewsAppDelegate.m
//  Overlapping Views
//
//  Created by Michael Harper on 5/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Overlapping_ViewsAppDelegate.h"

@implementation Overlapping_ViewsAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
