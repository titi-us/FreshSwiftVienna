//
//  FTUITreeItem.h
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTUrlLoader.h"
#import "FTOPMLItem.h"

@interface FTUITreeItem : NSObject
{
}

@property FTUrlLoader *loader;
@property FTOPMLItem *item;

+(FTUITreeItem*)treeItemFromItem:(FTOPMLItem*)item loader:(FTUrlLoader*)loader;

@end
