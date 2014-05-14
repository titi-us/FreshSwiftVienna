//
//  FTUITreeItem.m
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUITreeItem.h"

@implementation FTUITreeItem
@synthesize name, value;

+(FTUITreeItem*)treeItemFromName:(NSString*)name value:(NSString*)value
{
    FTUITreeItem *td = [[FTUITreeItem alloc] init];
    td.name = name;
    td.value = value;
    
    return td;
}

@end
