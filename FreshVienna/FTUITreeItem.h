//
//  FTUITreeItem.h
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTUITreeItem : NSObject
{
    NSString *name;
    NSString *value;
}

@property (copy) NSString *name;
@property (copy) NSString *value;

+(FTUITreeItem*)treeItemFromName:(NSString*)name value:(NSString*)value;

@end
