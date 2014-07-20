//
//  FTReadability.swift
//  FreshVienna
//
//  Created by Thibaut on 7/7/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTReadability
{
    let htmlParser:NDHpple
    
    init(htmlContent:String)
    {
        htmlParser = NDHpple(HTMLData: htmlContent);
    }
    
    func getImageUrlInHeader() -> String?
    {
        let xpath = "//meta[@property]"
        var titles = htmlParser.searchWithXPathQuery(xpath)

        if let actualTitles = titles
        {
            for title in actualTitles
            {
                if (title.attributes["property"] != nil)
                {
                    var object:AnyObject = title.attributes["property"]!;
                    var possibleValue:String? = object as? String;
                    
                    if (possibleValue != nil && possibleValue! == "og:image")
                    {
                        var objectContent:AnyObject = title.attributes["content"]!;
                        var content:String? = objectContent as? String;
                        if let actualContent = content
                        {
                            return actualContent;
                        }
                    }
                    
                }
                
                
            }
        }
        return nil;
    }
    
    func getReadableContent() -> String
    {
        let xpath = "//p/.."
        var paragraphs = htmlParser.searchWithXPathQuery(xpath)
        if let actualParagraph = paragraphs
        {
            var contentCount:Array<Int> = []
            var contentIndex:Array<NDHppleElement> = []
            println("has found \(actualParagraph.count) items");
            for paragraph in actualParagraph
            {
                    var hasFound = false;
                    for i in 0...(contentIndex.count - 1)
                    {
                        
                        if contentIndex[i] === paragraph
                        {
                            hasFound = true;
                            contentCount[i] += 1;
                        }
                        if hasFound
                        {
                            break
                        }
                    }
                    if !hasFound
                    {
                        contentIndex.append(paragraph)
                        contentCount.append(1);
                    }
            }
            
            var max = 0;
            var maxIndex = -1;
            var maxLength = 0;
            for i in 0...(contentCount.count - 1)
            {
                if max < contentCount[i]
                {
                    max = contentCount[i];
                    maxIndex = i;
                    maxLength = contentIndex[i].raw!.utf16count;
                } else if max == contentCount[i]
                {
                    if contentIndex[i].raw!.utf16count > maxLength
                    {
                        max = contentCount[i];
                        maxIndex = i;
                        maxLength = contentIndex[i].raw!.utf16count;
                    }
                }
            }
            
            if maxIndex > -1
            {
                println(contentIndex[maxIndex].raw!)
                var content = contentIndex[maxIndex];
                if content.raw != nil
                {
                    return content.raw!;
                }
            } else
            {
                println("cannot find max index in \(contentCount.count) elements");
            }
            
        }
        return htmlParser.data;
    }

    
}