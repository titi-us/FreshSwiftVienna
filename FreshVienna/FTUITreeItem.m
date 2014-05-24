//
//  FTUITreeItem.m
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUITreeItem.h"

@implementation FTUITreeItem
@synthesize item, loader;

+(FTUITreeItem*)treeItemFromItem:(FTOPMLItem*)item loader:(FTUrlLoader*)loader;
{
    FTUITreeItem *td = [[FTUITreeItem alloc] init];
    td.item = item;
    td.loader = loader;
    
    return td;
}

@end
