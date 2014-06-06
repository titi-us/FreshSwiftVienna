//
//  FTURLLoader.swift
//  FreshVienna
//
//  Created by Thibaut on 6/2/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTURLLoader : NSObject, NSURLConnectionDataDelegate, NSXMLParserDelegate
{
    var isLoading = false;
    var unreadCount = 0;
    var currentStringValue:NSMutableString = "";
    var loadedData:NSMutableData;
    var currentRssItem:FTRSSItem;
    var rssFeed:FTRSSFeed;
    var rssItems:FTRSSItem[] = [];

    
    init(urlString:String) {
        loadedData = NSMutableData.data();
        isLoading = true;
        currentRssItem = FTRSSItem();
        rssFeed = FTRSSFeed();
        super.init();
        var url:NSURL = NSURL.URLWithString(urlString);
        var request:NSURLRequest = NSURLRequest(URL: url);
        NSURLConnection.connectionWithRequest(request, delegate: self);
    }
    
    
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        loadedData.appendData(data);
    }

    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var xmlparser:NSXMLParser = NSXMLParser(data: loadedData);
        
        // this class will handle the events
        xmlparser.delegate = self;
        xmlparser.shouldResolveExternalEntities = false;

        // now parse the document
        var ok = xmlparser.parse();
        
        isLoading = ok;
    NSNotificationCenter.defaultCenter().postNotificationName("loading updated", object: self);

    }
    

    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
        
    {
        if elementName == "channel"
        {
            rssFeed = FTRSSFeed();
        }
        if elementName == "item"
        {
            currentRssItem = FTRSSItem();
        }
    }
    
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        currentStringValue.appendString(string);
    }
    
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (currentRssItem != nil)
        {
            
            if (elementName == "title")
            {
                currentRssItem.title = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "link")
            {
                currentRssItem.link = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "description")
            {
                currentRssItem.description = currentStringValue;
            }  else if (elementName == "comments")
            {
                currentRssItem.comments = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "guid")
            {
                currentRssItem.guid = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "pubDate")
            {
                currentRssItem.pubDate = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                var pubDate:NSDate = NSDate.dateWithNaturalLanguageString(currentRssItem.pubDate) as NSDate
                var cal:NSCalendar = NSCalendar.currentCalendar();
                
                if (cal.isDateInToday(pubDate))
                {
                    unreadCount += 1;
                }
            }
            
            
            if (elementName == "item")
            {
                rssItems.append(currentRssItem)
            }
        } else {
            
            
            if (elementName == "title")
            {
                rssFeed.title = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else if (elementName == "link" )
            {
                rssFeed.link = currentStringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    
    
}




