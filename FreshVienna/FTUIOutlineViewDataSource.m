//
//  FTUIOutlineViewDataSource.m
//  FreshVienna
//
//  Created by Thibaut on 5/12/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIOutlineViewDataSource.h"
#import "FTUIOutlineViewItem.h"

@implementation FTUIOutlineViewDataSource
@synthesize urls;
// Data Source methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return (item == nil) ? [urls count] : 0;
//    return (item == nil) ? [urls count] : [item numberOfChildren];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
//    return NO;
    return (item == nil) ? YES : NO;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    return (item == nil) ? [urls objectAtIndex:index] : nil;
}


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return (item == nil) ? @"/" : [item title];
}

@end
