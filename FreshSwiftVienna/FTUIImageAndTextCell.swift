//
//  FTImageAndTextCell.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUIImageAndTextCell : NSTextFieldCell
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
            
            if let faviconImage = treeItem.loader.rssFeed.faviconImage
            {
                self.image = faviconImage;
            }
            
        }

    }
    
    }
    
    
    override var cellSize: NSSize {
    get {
        var size = super.cellSize;
        size.width += (self.image ? self.image.size.width : 0) + 3;
        return size;
    }
    }
        
    override func drawWithFrame(cellFrame:NSRect, inView controlView:NSView)
    {
        var newCellFrame = cellFrame as CGRect;
        let imageSize = CGSize(width: 25, height: 15);
        var imageFrame:CGRect = CGRect();
        CGRectDivide(newCellFrame, &imageFrame, &newCellFrame, imageSize.width, CGRectEdge.MinXEdge)
        if (self.drawsBackground)
        {
            self.backgroundColor.set();
            NSRectFill(imageFrame);
        }

        if (self.image)
        {
            imageFrame.origin.y += 5;
            imageFrame.origin.x += 5;
            imageFrame.size = imageSize;
            imageFrame.size.width = 15;
            
            self.image.drawInRect(imageFrame, fromRect:NSZeroRect, operation:NSCompositingOperation.CompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil);
            self.title = self.title;
        }
        super.drawWithFrame(newCellFrame, inView:controlView);
    }
    
    override func titleRectForBounds(theRect: NSRect) -> NSRect
    {
        var titleRect:NSRect = super.titleRectForBounds(theRect);
        titleRect.origin.y = 5;
        return titleRect;

    }
    
    

}