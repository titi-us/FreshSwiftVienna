//
//  FTUISplitViewDelegate.swift
//  FreshVienna
//
//  Created by Thibaut on 6/8/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa

class FTUISplitViewDelegate : NSObject, NSSplitViewDelegate
{    
    func splitView(splitView: NSSplitView!, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat
    {
        
        if (dividerIndex == 0)
        {
            return proposedMinimumPosition + 250;
        }
        return proposedMinimumPosition + 200;
        
    }
    
    
    func splitView(splitView: NSSplitView!, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat
    {
        return proposedMaximumPosition - 100;
    }

}