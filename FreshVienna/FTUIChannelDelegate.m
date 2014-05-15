//
//  FTUIChannelDelegate.m
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIChannelDelegate.h"
#import "FTRSSItemAttributes.h"
#import "FTUIArticleCellView.h"

@implementation FTUIChannelDelegate
@synthesize rssItems;

#pragma TableDataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.rssItems.count;
}


#pragma TableView Delegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 330;
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    // Get an existing cell with the MyView identifier if it exists
    FTUIArticleCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
        
        // Create the new NSTextField with a frame of the {0,0} with the width of the table.
        // Note that the height of the frame is not really relevant, because the row height will modify the height.
        result = [[FTUIArticleCellView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 150)];
        
        // The identifier of the NSTextField instance is set to MyView.
        // This allows the cell to be reused.
        result.identifier = @"MyView";
    }
    
    FTRSSItemAttributes* item = [self.rssItems objectAtIndex:row];
    
    [result setImageUrl:item.imageUrl];
    [result setTitle:item.title];
    [result setDescription:item.description];
    [result setAuthor:item.guid];
    [result setPubDate:item.pubDate];
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
//    result
//    result.stringValue = [self.nameArray objectAtIndex:row];
    
    // Return the result
    return result;
    
}



//// cell based
//- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
//{
//    NSString *title = [(FTRSSItemAttributes*) [self.rssItems objectAtIndex:rowIndex] title];
//    title = [title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    return title;
//}


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
