//
//  FTUIOutlineViewDataSource.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUIOutlineViewDataSource : NSObject, NSOutlineViewDataSource
{
    var data:AnyObject[] = [];

    
    func outlineView(outlineView: NSOutlineView!, numberOfChildrenOfItem item: AnyObject!) -> Int
    {
        return (item == nil) ? data.count : 0;
    }

    func outlineView(outlineView: NSOutlineView!, isItemExpandable item: AnyObject!) -> Bool
    {
        return (item == nil);
    }
    
    func outlineView(outlineView: NSOutlineView!, child index: Int, ofItem item: AnyObject!) -> AnyObject!
    {
        return (item == nil) ? data[index] : nil;
    }
    
    func outlineView(outlineView: NSOutlineView!, objectValueForTableColumn tableColumn: NSTableColumn!, byItem item: AnyObject!) -> AnyObject!
    {
        return item;
    }

}