//
//  FTUIChannelDelegate.m
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIChannelDelegate.h"
#import "FTRSSItemAttributes.h"
@implementation FTUIChannelDelegate
@synthesize rssItems;

#pragma TableDataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.rssItems.count;
}


#pragma TableView Delegate
// cell based
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSString *title = [(FTRSSItemAttributes*) [self.rssItems objectAtIndex:rowIndex] title];
    title = [title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return title;
}


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSTableView *tableView = [aNotification object];
    if (tableView && [tableView selectedRow] > -1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rssItemClicked" object:[self.rssItems objectAtIndex:[tableView selectedRow]]];
        
//        NSString *link = [(FTRSSItemAttributes*) [self.rssItems objectAtIndex:[tableView selectedRow]] link];
//        link = [link stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:link]];
        
    }
}


@end
