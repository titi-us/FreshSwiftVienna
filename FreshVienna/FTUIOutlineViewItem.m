//
//  FTUIOutlineViewItem.m
//  FreshVienna
//
//  Created by Thibaut on 5/12/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIOutlineViewItem.h"

@implementation FTUIOutlineViewItem

static FTUIOutlineViewItem *rootItem = nil;
static NSMutableArray *leafNode = nil;

+ (void)initialize {
    if (self == [FTUIOutlineViewItem class]) {
        leafNode = [[NSMutableArray alloc] init];
    }
}

- (id)initWithName:(NSString *)aName parent:(FTUIOutlineViewItem *)parentItem {
    self = [super init];
    if (self) {
        name = aName;
        parent = parentItem;
    }
    return self;
}


+ (FTUIOutlineViewItem *)rootItem {
    if (rootItem == nil) {
        rootItem = [[FTUIOutlineViewItem alloc] initWithName:@"root" parent:nil];
    }
    return rootItem;
}


// Creates, caches, and returns the array of children
// Loads children incrementally
- (NSArray *)children {
    return children;
}


- (NSString *)name {
    // If no parent, return our own relative path
    return name;
}

- (void)addChildWithName:(NSString*)aName
{
    if (children == nil)
    {
        children = [NSMutableArray array];
    }
    FTUIOutlineViewItem *child = [[FTUIOutlineViewItem alloc] initWithName:aName parent:self];
    [children addObject:child];
}


- (FTUIOutlineViewItem *)childAtIndex:(NSUInteger)n {
    return [[self children] objectAtIndex:n];
}


- (NSInteger)numberOfChildren {
    NSArray *tmp = [self children];
    return (tmp == leafNode) ? (-1) : [tmp count];
}

@end
