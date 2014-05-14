//
//  FTUIOutlineViewItem.h
//  FreshVienna
//
//  Created by Thibaut on 5/12/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTUIOutlineViewItem : NSObject
{
    NSString *name;
    FTUIOutlineViewItem *parent;
    NSMutableArray *children;
}

+ (FTUIOutlineViewItem *)rootItem;
- (NSInteger)numberOfChildren;// Returns -1 for leaf nodes
- (FTUIOutlineViewItem *)childAtIndex:(NSUInteger)n; // Invalid to call on leaf nodes
- (NSString *)name;
- (void)addChildWithName:(NSString*)name;
@end
