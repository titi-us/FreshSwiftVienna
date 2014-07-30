//
//  FTUIWebViewDelegate.swift
//  FreshVienna
//
//  Created by Thibaut on 6/8/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import WebKit

class FTUIWebViewDelegate:NSViewController
{
     
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!)
    {
        
        
        var scrollView = sender.mainFrame.frameView.documentView.enclosingScrollView;
        
        //        scrollView.verticalScroller.controlSize = NSControlSize.SmallControlSize;
        //        scrollView!.horizontalScroller.controlSize = NSControlSize.SmallControlSize;
        
    }
    
    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
    {
        
        var actionNumber = actionInformation[WebActionNavigationTypeKey] as NSNumber;
        if ( actionNumber.integerValue == 0 )
        {
            listener.ignore();
        }
        else
        {
            listener.use();
        }
        

    }
    
    
    
    
}