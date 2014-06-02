//
//  FTUIOutlineViewDataSource.m
//  FreshVienna
//
//  Created by Thibaut on 5/12/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIOutlineViewDataSource.h"
#import "FTUIOutlineViewItem.h"
#import "FTUITreeItem.h"

@implementation FTUIOutlineViewDataSource
@synthesize data;
// Data Source methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return (item == nil) ? [data count] : 0;
//    return (item == nil) ? [urls count] : [item numberOfChildren];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
//    return NO;
    return (item == nil) ? YES : NO;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    return (item == nil) ? [data objectAtIndex:index] : nil;
}


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return item;
//
//    
//    FTUITreeItem *treeItem = item;
//    
//    return treeItem;
//    if ([treeItem.loader isLoading])
//    {
//        return [NSString stringWithFormat:@"%@ - loading", treeItem.item.title];
//    }
//    return [NSString stringWithFormat:@"%@ - %li", treeItem.item.title, treeItem.loader.unreadCount];
}


@end
