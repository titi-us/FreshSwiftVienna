//
//  FTUIChannelDelegate.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUIChannelDelegate : NSObject, NSTableViewDataSource, NSTableViewDelegate
{
    var rssItems:[FTRSSItem] = [];
    var feedItem:FTRSSFeed? = nil;
    
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int
    {
        return self.rssItems.count;

    }

    func tableView(tableView: NSTableView!, heightOfRow row: Int) -> CGFloat
    {
        var item = self.rssItems[row];
        return (item.imageUrl != nil) ? 330 : 120;
    }
    
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int) -> NSView!
    {
        var item = rssItems[row];
        var result:NSView?;
        var hasImage = item.imageUrl != nil;
        if (hasImage)
        {
            result = tableView.makeViewWithIdentifier("MyView", owner: self) as? NSView;
            
        } else
        {
            result = tableView.makeViewWithIdentifier("MyViewNoImage", owner: self) as? NSView;
        }
        
        // There is no existing cell to reuse so create a new one
        if (!result) {
            if (hasImage)
            {
                result = FTUIArticleCellView(frame:CGRectMake(0, 0, tableView.bounds.size.width, 150));
                result!.identifier = "MyView";
            } else{
                result = FTUIArticleCellViewNoImageView(frame:CGRectMake(0, 0, tableView.bounds.size.width, 150));
                result!.identifier = "MyViewNoImage";
            }
        }
        
        if (!hasImage)
        {
            setupCell(result as FTUIArticleCellViewNoImageView, withItem:item);
        } else
        {
            setupCellWithImage(result as FTUIArticleCellView, withItem:item);
        }
        
        // Return the result
        return result;

    }

    func setupCell(view:FTUIArticleCellViewNoImageView, withItem item:FTRSSItem)
    {
        view.title(item.title);
        view.author(feedItem!.title);
        view.pubDate(item.pubDate);
        view.favicon(feedItem!.faviconImage);
    }
    
    func setupCellWithImage(view:FTUIArticleCellView, withItem item:FTRSSItem)
    {
        view.imageUrl(item.imageUrl!);
        view.title(item.title);
        view.author(feedItem!.title);
        view.pubDate(item.pubDate);
    }
    
    
    func tableViewSelectionDidChange(aNotification:NSNotification)
    {
        var tableView:NSTableView = aNotification.object as NSTableView;
        if (tableView != nil && tableView.selectedRow > -1)
        {
            NSNotificationCenter.defaultCenter().postNotificationName("rssItemClicked", object: rssItems[tableView.selectedRow]);
        }
    }


    
}