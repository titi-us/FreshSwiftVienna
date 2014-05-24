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
#import "FTUIArticleCellViewNoImageView.h"

@implementation FTUIChannelDelegate
@synthesize rssItems, feedItem;

#pragma TableDataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.rssItems.count;
}


#pragma TableView Delegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    FTRSSItemAttributes* item = [self.rssItems objectAtIndex:row];
    return ([item imageUrl] != nil) ? 330 : 120;
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    
    FTRSSItemAttributes* item = [self.rssItems objectAtIndex:row];
    NSView *result;
    BOOL hasImage = [item imageUrl] != nil;
    if (hasImage)
    {
        result = [tableView makeViewWithIdentifier:@"MyView" owner:self];

    } else
    {
        result = [tableView makeViewWithIdentifier:@"MyViewNoImage" owner:self];
    }
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
        if (hasImage)
        {
            result = [[FTUIArticleCellView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 150)];
            result.identifier = @"MyView";
        } else{
            result = [[FTUIArticleCellViewNoImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 150)];
            result.identifier = @"MyViewNoImage";
        }
    }
    
    if (!hasImage)
    {
        [self setupCell:(FTUIArticleCellViewNoImageView*)result withItem:item];
    } else
    {
        [self setupCellWithImage:(FTUIArticleCellView*)result withItem:item];
    }

    // Return the result
    return result;
    
}

- (void)setupCell:(FTUIArticleCellViewNoImageView*)view withItem:(FTRSSItemAttributes*)item
{
    [view setTitle:item.title];
    [view setDescription:item.description];
    [view setAuthor:feedItem.title];
    [view setPubDate:item.pubDate];
}



- (void)setupCellWithImage:(FTUIArticleCellView*)view withItem:(FTRSSItemAttributes*)item
{
    [view setImageUrl:item.imageUrl];
    [view setTitle:item.title];
    [view setDescription:item.description];
    [view setAuthor:feedItem.title];
    [view setPubDate:item.pubDate];
}


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSTableView *tableView = [aNotification object];
    if (tableView && [tableView selectedRow] > -1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rssItemClicked" object:[self.rssItems objectAtIndex:[tableView selectedRow]]];
        
    }
}


@end
