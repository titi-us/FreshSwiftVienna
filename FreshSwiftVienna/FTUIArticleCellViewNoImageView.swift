//
//  FTUIArticleCellViewNoImageView.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUIArticleCellViewNoImageView: NSTableCellView
{
    var titleTextfield:NSTextField = NSTextField();
    var authorTextfield:NSTextField = NSTextField();
    var dateTextfield:NSTextField = NSTextField();
    var faviconView:NSImageView = NSImageView();
    
    init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect);
        initCell();
    }
    
    func initCell()
    {
        titleTextfield = NSTextField(frame:CGRectMake(10, 10, self.bounds.size.width - 20, 70));
        authorTextfield = NSTextField(frame:CGRectMake(10, 80, self.bounds.size.width/2, 40));
        dateTextfield = NSTextField(frame:CGRectMake(self.bounds.size.width/2, 80, self.bounds.size.width/2, 40));
        faviconView = NSImageView(frame:CGRectMake(10, 80, 30, 30));

        
        setupTextField(titleTextfield);
        setupTextField(authorTextfield);
        setupTextField(dateTextfield);
        
        addSubview(faviconView);

        
        
        titleTextfield.font = NSFont.boldSystemFontOfSize(18);
        dateTextfield.textColor = NSColor(calibratedRed: 173/255.0, green: 178/255.0, blue: 187/255.0, alpha: 1);
        
        autoresizesSubviews = true;
        wantsLayer = true;
        layer.masksToBounds = true;
        layer.borderWidth  = 0.5;
        
        layer.backgroundColor = CGColorGetConstantColor(kCGColorWhite);
        layer.borderColor = CGColorGetConstantColor(kCGColorBlack);
    }
    
    func setupTextField(aTextfield:NSTextField)
    {
        aTextfield.editable = false;
        aTextfield.drawsBackground = false;
        aTextfield.bordered = false;
        self.addSubview(aTextfield);
    }
    
    func isFlipped() -> Bool
    {
        return true;
    }
    
    
    func title(value:String?)
    {
        self.titleTextfield.stringValue = value;
    }
    
    func author(value:String?)
    {
        self.authorTextfield.stringValue = value;
    }
    
    func pubDate(value:String?)
    {
        self.dateTextfield.stringValue = value;
    }

    func favicon(image:NSImage?)
    {
        if let faviconImage = image
        {
            faviconView.image = faviconImage;
            authorTextfield.hidden = true;
        } else
        {
            faviconView.image = nil;
            authorTextfield.hidden = false;
        }

    }

}