//
//  FTURLOperation.swift
//  FreshVienna
//
//  Created by Thibaut on 6/7/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation


class FTURLOperation : NSOperation
{
    let urlLoader:FTURLLoader;
    
    init(loader:FTURLLoader)
    {
        urlLoader=loader;
    }
    
    
    override func main()
    {
        if self.cancelled
        {
            return;
        }
        
        urlLoader.start();
    }
}