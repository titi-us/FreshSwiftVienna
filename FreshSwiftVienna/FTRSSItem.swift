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
    var link:String = "http://www.google.com";
    var comments:String = "";
    var description:String = "" {
    willSet(newDescription) {
        if (newDescription != nil)
        {
            var error:NSError?;
            var detector:NSDataDetector = NSDataDetector(types: NSTextCheckingType.Link.toRaw(), error: &error);
            var range = NSMakeRange(0 as Int, newDescription.utf16Count)
            var matches:[NSTextCheckingResult] = detector.matchesInString(newDescription, options: NSMatchingOptions.ReportCompletion, range: range) as [NSTextCheckingResult];
            
            for match in matches {
            
            
                if (match.resultType.toRaw() == NSTextCheckingType.Link.toRaw()) {
                    var url:NSURL = match.URL;
                    
                    if let myPath = url.path
                    {
                        
                        
                        
                        var ranges:Range<String.Index>? = myPath.rangeOfString("twitter", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil);

                        if (ranges && !ranges!.isEmpty)
                        {
                            break;
                        }
                        
                        if ((myPath.hasSuffix(".gif") || myPath.hasSuffix(".jpg") || myPath.hasSuffix(".png")))
                        {
                            imageUrl = url;
                            break;
                        }
                    }
                }
            }
        }

    }
    }
    var pubDate:String = "";
    var guid:String = "";
    var author:String = "";
    var imageUrl:NSURL? = nil;
}

