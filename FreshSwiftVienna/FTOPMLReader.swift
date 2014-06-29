//
//  FTOPMLReader.swift
//  FreshVienna
//
//  Created by Thibaut on 6/3/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTOPMLReader: NSObject, NSXMLParserDelegate
{
    var loadedUrls:FTOPMLItem[] = [];

    func loadUrl(url:String) -> FTOPMLItem[]
    {
        loadedUrls = [];
        var parser:NSXMLParser? = NSXMLParser(contentsOfURL:NSURL.fileURLWithPath(url));
        parser!.delegate = self;
        parser!.shouldResolveExternalEntities = false;
        
        // now parse the document
        parser!.parse();
        parser = nil;
        return loadedUrls;
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
    {
        
        if (attributeDict != nil)
        {
            if attributeDict.objectForKey("xmlUrl")
            {
                var item = FTOPMLItem(xmlUrl: attributeDict.objectForKey("xmlUrl") as String, title:attributeDict.objectForKey("text") as? String);
                loadedUrls.append(item);
            }
        }
    }
}