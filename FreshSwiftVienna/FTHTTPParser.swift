//
//  FTHTTPParser.swift
//  FreshVienna
//
//  Created by Thibaut on 7/3/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTHTTPParser : NSObject, NSXMLParserDelegate
{
    var metaFound:Dictionary<String,String?> = Dictionary<String,String?>();
    
    
    func startWithData(data:NSData?) -> Bool
    {
        metaFound = Dictionary<String,String?>();
        if let actualData = data
        {
            var xmlparser:NSXMLParser = NSXMLParser(data: data);
            
            // this class will handle the events
            xmlparser.delegate = self;
            xmlparser.shouldResolveExternalEntities = false;

            return xmlparser.parse();

        }
        return true;
    }
    
    
    func startWithUrl(url:NSURL?) -> Bool
    {
        metaFound = Dictionary<String,String?>();
        var xmlparser:NSXMLParser? = NSXMLParser(contentsOfURL: url);
        if let actualParser = xmlparser
        {
            // this class will handle the events
            actualParser.delegate = self;
            actualParser.shouldResolveExternalEntities = false;
            return actualParser.parse();
        }
        return true;

    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
    {
        
        if (attributeDict != nil)
        {
            if let relString = attributeDict["rel"] as? NSString
            {
                if (relString == "shortcut icon")
                {
                    metaFound["favicon"] = attributeDict["href"] as? String;
                    println("has found favicon")
                }
            }
        }
    }

}