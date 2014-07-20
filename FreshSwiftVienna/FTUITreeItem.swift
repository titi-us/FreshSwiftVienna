//
//  FTUITreeItem.swift
//  FreshVienna
//
//  Created by Thibaut on 6/3/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import CoreData

class FTUITreeItem : NSObject
{
    var loader:FTURLLoader;
    var item:FTOPMLItem;

    init(loader aLoader:FTURLLoader, item anItem:FTOPMLItem)
    {
        loader = aLoader;
        item = anItem;
    }
}