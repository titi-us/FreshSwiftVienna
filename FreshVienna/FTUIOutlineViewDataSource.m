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

// Data Source methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    
    return (item == nil) ? 1 : [item numberOfChildren];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return (item == nil) ? YES : ([item numberOfChildren] != -1);
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    return (item == nil) ? [FTUIOutlineViewItem rootItem] : [(FTUIOutlineViewItem *)item childAtIndex:index];
}


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return (item == nil) ? @"/" : [item name];
}

@end
