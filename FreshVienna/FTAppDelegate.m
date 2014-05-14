//
//  FTAppDelegate.m
//  FreshVienna
//
//  Created by Thibaut on 5/8/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//


#import "FTAppDelegate.h"
#import "FTUIMainViewController.h"
@interface FTAppDelegate()
{
    FTUIMainViewController *mainViewController;
}


@end
@implementation FTAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    NSLog(@"Start");
    // load file
    
    if (mainViewController == nil)
    {
        mainViewController = [[FTUIMainViewController alloc] initWithNibName:@"FTUIMainViewController" bundle:nil];
    }
    
    NSRect frame = [self.window frame];
    frame.size.width = 1024;
    
    CGFloat currentHeight = frame.size.height;
    frame.size.height = 800;
    
    frame.origin.y -= (800 - currentHeight);
    [self.window setFrame:frame display:YES];

    [self.window setContentView:mainViewController.view];
    
}




@end
