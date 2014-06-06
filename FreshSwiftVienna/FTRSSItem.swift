//
//  FTRSSItem.swift
//  FreshVienna
//
//  Created by Thibaut on 6/3/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTRSSItem
{
    var title:String = "";
    var link:String = "";
    var comments:String = "";
    var description:String = "" {
    willSet(newDescription) {
        if (newDescription != nil)
        {
            var error:NSError?;
            var detector:NSDataDetector = NSDataDetector(types: NSTextCheckingType.Link.toRaw(), error: &error);
            var range = NSMakeRange(0 as Int, newDescription.utf16count)
            var matches:NSTextCheckingResult[] = detector.matchesInString(newDescription, options: NSMatchingOptions.ReportCompletion, range: range) as NSTextCheckingResult[];
            
            for match in matches {
                if (match.resultType.value == NSTextCheckingType.Link.value) {
                    var url:NSURL = match.URL;
                    if (url.path?.hasSuffix("jpg") || url.path?.hasSuffix("png"))
                    {
                        imageUrl = url;
                        break;
                    }
                }
            }
        }

    }
    }
    var pubDate:String = "";
    var guid:String = "";
    var author:String = "";
    var imageUrl:NSURL = NSURL();
    
}

