//
//  FTUIArticleCellView.swift
//  FreshVienna
//
//  Created by Thibaut on 6/4/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUIArticleCellView : NSTableCellView
{
    var myImage:NSImage?;
    var titleTextfield:NSTextField = NSTextField();
    var myImageView:NSImageView = NSImageView();
    var authorTextfield:NSTextField = NSTextField();
    var dateTextfield:NSTextField = NSTextField();
    
    
    init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect);
        initCell();
    }
    
    func initCell()
    {
        myImageView = NSImageView(frame:CGRectMake(0, 0, self.bounds.size.width, 200));
        titleTextfield = NSTextField(frame:CGRectMake(10, 210, self.bounds.size.width - 20, 40));
        authorTextfield = NSTextField(frame:CGRectMake(0, 280, self.bounds.size.width/2, 40));
        dateTextfield = NSTextField(frame:CGRectMake(self.bounds.size.width/2, 280, self.bounds.size.width/2, 40));
        
        
        setupTextField(titleTextfield);
        setupTextField(authorTextfield);
        setupTextField(dateTextfield);

        titleTextfield.font = NSFont.boldSystemFontOfSize(15);
        dateTextfield.textColor = NSColor(calibratedRed: 173/255.0, green: 178/255.0, blue: 187/255.0, alpha: 1);
        
        addSubview(myImageView);
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
    
    func imageUrl(value:NSURL)
    {
        if (value != nil)
        {
            if (myImage != nil)
            {
                myImage = nil;
            }
            myImage = NSImage(byReferencingURL: value)
            var targetImage:NSImage = FTUIArticleCellView.scaleImageToFillView(myImageView, fromImage:myImage!);
            myImage = targetImage;
        } else
        {
            myImage = nil;
        }
        myImageView.image = myImage;
    }
    
    
    class func scaleImageToFillView(imageView:NSImageView, fromImage image:NSImage) -> NSImage
    {
        var targetImage = NSImage(size: imageView.frame.size);
        var imageSize = image.size;
        var imageViewSize = imageView.frame.size;
        var newImageSize = image.size;
        
        
        var imageAspectRatio = imageSize.height/imageSize.width;
        var imageViewAspectRatio = imageViewSize.height/imageViewSize.width;
        
        
        if (imageAspectRatio < imageViewAspectRatio)
        {
            newImageSize.width = imageSize.height / imageViewAspectRatio;
        } else
        {
            newImageSize.height = imageSize.width * imageViewAspectRatio;
        }
        
        var srcRect = NSMakeRect(imageSize.width/2.0-newImageSize.width/2.0,
            imageSize.height/2.0-newImageSize.height/2.0,
            newImageSize.width,
            newImageSize.height);
        
        
        // @{NSImageHintInterpolation: NSImageInterpolationHigh}
        targetImage.lockFocus();
        image.drawInRect(imageView.frame, fromRect: srcRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0, respectFlipped: true, hints: nil);
        
    
        targetImage.unlockFocus();
        return targetImage;
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
    
}