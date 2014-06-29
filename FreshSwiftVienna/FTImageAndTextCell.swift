//
//  FTImageAndTextCell.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTImageAndTextCell : NSTextFieldCell
{

    override var objectValue: AnyObject! {
    get {
        return super.objectValue;
    }
    
    set {
        if newValue is FTUITreeItem
        {
            var treeItem:FTUITreeItem = newValue as FTUITreeItem;
            self.title = treeItem.item.title;
            
            super.objectValue = treeItem.item.title;
            
            if (treeItem.loader.unreadCount == 0)
            {
                self.backgroundColor = NSColor(calibratedRed: 0.27, green: 0.78, blue: 0.31 , alpha: 1);
                self.font = NSFont.systemFontOfSize(12);
            } else if (treeItem.loader.unreadCount == 1)
            {
                self.backgroundColor = NSColor(calibratedRed: 0.76, green: 0.59, blue: 0.29 , alpha: 1);
                self.font = NSFont.boldSystemFontOfSize(12);
            } else
            {
                self.backgroundColor = NSColor(calibratedRed: 0.74, green: 0.29, blue: 0.27 , alpha: 1);
                self.font = NSFont.boldSystemFontOfSize(12);
            }
        }

    }
    }
    

}