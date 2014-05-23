//
//  FTUIMainViewController.h
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTRSSItemAttributes.h"

@interface FTUIMainViewController : NSViewController<NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate, NSOutlineViewDelegate>
{
}

-(void)doubleClickOnRssItem:(id)object;
-(void)loadWebView:(FTRSSItemAttributes*)item;
@end
