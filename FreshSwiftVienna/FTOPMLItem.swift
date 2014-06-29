//
//  FTOPMLItem.swift
//  FreshVienna
//
//  Created by Thibaut on 6/3/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation

class FTOPMLItem
{
    var xmlUrl:String;
    var title:String;
    
    init(xmlUrl url:String, title aTitle:String?)
    {
        xmlUrl = url;
        if let myTitle = aTitle
        {
            title = myTitle;
        } else
        {
            title = xmlUrl;
        }
    }
    
}