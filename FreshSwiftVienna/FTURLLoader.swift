//
//  FTURLLoader.swift
//  FreshVienna
//
//  Created by Thibaut on 6/2/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTURLLoader : NSObject, NSURLConnectionDataDelegate, NSXMLParserDelegate
{
    var isLoading = false;
    var unreadCount = 0;
    var currentStringValue:String = "";
    var currentRssItem:FTRSSItem?;
    var rssFeed:FTRSSFeed;
    var rssItems:[FTRSSItem] = [];
    let urlPath:String;
    var hasTimestamp:Bool;
    
    init(urlPath:String) {
        self.urlPath = urlPath;
        rssFeed = FTRSSFeed();
        hasTimestamp = false;
        super.init();
        
    }
    
    func start()
    {
        println("start for \(urlPath)");
        isLoading = true;
        var url:NSURL = NSURL.URLWithString(urlPath);
        var request:NSURLRequest = NSURLRequest(URL: url);
        var response:NSURLResponse?;
        var error:NSError?;
        let data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        if let actualError = error
        {
            println("can't download \(url), \(actualError)")
        } else
        {
            parseData(data);
        }
    }
    
    func parseData(data:NSData)
    {
        var xmlparser:NSXMLParser = NSXMLParser(data: data);
        
        // this class will handle the events
        xmlparser.delegate = self;
        xmlparser.shouldResolveExternalEntities = false;
        
        // now parse the document
        var ok = xmlparser.parse();
        // TODO, parse link to get favicon
        
        if let myImage = loadFavicon(rssFeed.link, relativeUrl: nil)
        {
            rssFeed.faviconImage = FTURLLoader.roundCorners(myImage);
        } else
        {
            var parser = FTHTTPParser();
            parser.startWithUrl(NSURL(string: rssFeed.link));
            
            if parser.metaFound["favicon"] && parser.metaFound["favicon"]!
            {
                if let myImage = loadFavicon(rssFeed.link, relativeUrl: parser.metaFound["favicon"]!)
                {
                    rssFeed.faviconImage = FTURLLoader.roundCorners(myImage);
                }
            }
        }
        
        var maxCount = hasTimestamp ? unreadCount : rssItems.count;
                
        for i in 0...(maxCount - 1)
        {
            if (rssItems[i].imageUrl == nil || !hasTimestamp)
            {
                let myUurl:NSURL? = NSURL(string: rssItems[i].link);
                if let myRealUrl = myUurl
                {
                    var error:NSError?;
                    var nsString:NSString? = NSString.stringWithContentsOfURL(myRealUrl, encoding:NSUTF8StringEncoding, error: &error);
                    var str:String? = nsString as String?
                    if str != nil
                    {
                        
                        let htmlParser = FTReadability(htmlContent: str!);
                        
                        if !hasTimestamp
                        {
                            rssItems[i].description = htmlParser.getReadableContent()
                        }

                        
                        var possibleImagePath:String? = htmlParser.getImageUrlInHeader();
                        if let actualContent = possibleImagePath
                        {
                            rssItems[i].imageUrl = NSURL(string: actualContent)
                        }
                        
                    }

                }

            }

        }
        
        
        
        
        isLoading = ok;
        println("done for \(urlPath)");
//        NSNotificationCenter.defaultCenter().postNotificationName("loading updated", object: self);
    }
    
    
    func loadFavicon(baseFaviconUrl:String?, relativeUrl:String?) -> NSImage?
    {
        println("loading \(baseFaviconUrl), with relative \(relativeUrl)")
        if let myUrl:String = baseFaviconUrl
        {
            if !myUrl.isEmpty
            {
                if let url = NSURL(string: myUrl) as NSURL?
                {
                    var fullFaviconUrl:NSURL?;
                    if relativeUrl != nil
                    {
                        if relativeUrl!.hasPrefix("http")
                        {
                            fullFaviconUrl = NSURL.URLWithString(relativeUrl!);
                        } else
                        {
                            fullFaviconUrl = NSURL.URLWithString(relativeUrl!, relativeToURL: url.absoluteURL)
                        }

                    } else
                    {
                        fullFaviconUrl = NSURL.URLWithString("/favicon.ico", relativeToURL: url.absoluteURL)
                    }
                    
                    if let faviconUrl = fullFaviconUrl
                    {
                        if let image:NSImage = NSImage(contentsOfURL: faviconUrl) as NSImage?
                        {
                            if image.valid
                            {
                                return image;
                            }
                        }
                    }
                }
            }
        }
        return nil;

    }
    
    
    
    // async
//    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
//    {
//        loadedData.appendData(data);
//    }
//
//    func connectionDidFinishLoading(connection: NSURLConnection!)
//    {
//        parseData(self.loadedData);
//    }
    

    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
        
    {
        if elementName == "channel"
        {
            rssFeed = FTRSSFeed();
        }
        if elementName == "item"
        {
            if let item = currentRssItem
            {
                if (!item.imageUrl)
                {
                    //
                    //                    let url:NSURL = NSURL.URLWithString(currentRssItem.link);
                    //                    var myRequest = NSMutableURLRequest(URL: url);
                    //                    var response:NSURLResponse?;
                    //                    var error:NSError?;
                    //
                    //                    if let data:NSData? = NSURLConnection.sendSynchronousRequest(myRequest, returningResponse: &response, error: &error)
                    //                    {
                    //                        println(NSString(data: data, encoding: NSUTF8StringEncoding));
                    //                    }

                }
            }
            currentRssItem = FTRSSItem();
        }
    }
    
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        currentStringValue += string;
    }
    
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if let item = currentRssItem
        {            
            if (elementName == "title")
            {
                item.title = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
            } else if (elementName == "link")
            {
                item.link = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "description")
            {
                item.description = currentStringValue;
            }  else if (elementName == "comments")
            {
                item.comments = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "guid")
            {
                item.guid = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "pubDate")
            {
                hasTimestamp = true;
                item.pubDate = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                var pubDate:NSDate = NSDate.dateWithNaturalLanguageString(item.pubDate) as NSDate
                var cal:NSCalendar = NSCalendar.currentCalendar();
                
                if (cal.isDateInToday(pubDate))
                {
                    unreadCount += 1;
                }
            }
            
            
            if (elementName == "item")
            {
                rssItems.append(item);
            }
        } else {
            
            
            if (elementName == "title")
            {
                rssFeed.title = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "link" )
            {
                rssFeed.link = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
            } else if (elementName == "description" )
            {
                rssFeed.description = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "language")
            {
                rssFeed.language = currentStringValue;
            } else if (elementName == "copyright")
            {
                rssFeed.copyright = currentStringValue;
            } else if (elementName == "lastBuildDate")
            {
                rssFeed.lastBuildDate = currentStringValue;
            } else if (elementName == "generator")
            {
                rssFeed.generator = currentStringValue;
            } else if (elementName == "docs")
            {
                rssFeed.docs = currentStringValue;
            }
        }
        currentStringValue = "";

    }
    
    
    class func roundCorners(image:NSImage) -> NSImage
    {
        let existingSize = image.size;
        let newSize = NSMakeSize(existingSize.height, existingSize.width);
        var newImage = NSImage(size: newSize);
        newImage.lockFocus();
        

        let imageFrame = NSRectFromCGRect(CGRectMake(0,0,newSize.width,newSize.height));
        var clipPath:NSBezierPath = NSBezierPath(roundedRect: imageFrame, xRadius: 200, yRadius: 200);
        clipPath.windingRule = NSWindingRule.EvenOddWindingRule;
        clipPath.addClip();
        
        
        image.drawAtPoint(NSZeroPoint, fromRect: NSMakeRect(0, 0, newSize.width, newSize.height) , operation: NSCompositingOperation.CompositeSourceOver, fraction: 1);
        
        newImage.unlockFocus();
        return newImage;
        
    }
    
    
}




