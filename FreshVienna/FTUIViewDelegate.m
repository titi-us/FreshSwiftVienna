//
//  FTUIViewDelegate.m
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIViewDelegate.h"

@implementation FTUIViewDelegate
@synthesize urls;

#pragma TableDataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.urls.count;
}


#pragma TableView Delegate
// cell based
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return [self.urls objectAtIndex:rowIndex];
}

@end
