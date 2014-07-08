
//
//  FTImageHTTPParser.swift
//  FreshVienna
//
//  Created by Thibaut on 7/6/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation


class FTImageHTTPParser : FTHTTPParser
{
    override func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
    {
        
        if (attributeDict != nil)
        {
            if let relString = attributeDict["property"] as? NSString
            {
                if (relString == "og:image")
                {
                    metaFound["image"] = attributeDict["content"] as? String;
                    println("has found image")
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!)
    {
        println(parseError.description);
    }

}
