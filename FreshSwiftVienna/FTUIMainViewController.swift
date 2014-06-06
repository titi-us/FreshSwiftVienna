//
//  FTUIMainViewController.swift
//  FreshVienna
//
//  Created by Thibaut on 6/2/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class FTUIMainViewController : NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSSplitViewDelegate, NSOutlineViewDelegate
{
    
    // delegates
    var channelDelegate:FTUIChannelDelegate;
    
    // data
    var urls:FTOPMLItem[];
    var loaders:FTURLLoader[];
    var outlineDataSource:FTUIOutlineViewDataSource;
    
    
    //views
    var splitView:NSSplitView;
    var tableView:NSTableView;
    var tableContainer:NSScrollView;
    var webContainer:NSScrollView;
    var webView:WebView;
    var outlineView:NSOutlineView;
    
    // temp views
    var newTableContainer:NSScrollView;
    
    
    // WebView HTML and CSS
    var htmlTemplate:String?;
    var cssTemplate:String?;
    
    var treeArray:FTUITreeItem[];

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        splitView = NSSplitView();
        tableView = NSTableView();
        tableContainer = NSScrollView();
        webContainer = NSScrollView();
        outlineView = NSOutlineView();
        newTableContainer = NSScrollView();
        webView = WebView();
        treeArray = [];
        loaders = [];

        var reader:FTOPMLReader = FTOPMLReader();
        let mainBundle = NSBundle.mainBundle();
        
        if let filePath:String = mainBundle.pathForResource("Test", ofType: "opml")
        {
            urls = reader.loadUrl(filePath);
        } else
        {
            urls = [];
        }
        
        
        for url in urls {
            var urlLoader:FTURLLoader = FTURLLoader(urlString:url.xmlUrl);
            loaders.append(urlLoader);
            treeArray.append(FTUITreeItem(loader: urlLoader, item: url));
        }
        
        

        
        var error:NSError?;
        
        
        if let htmlTemplatePath:String = mainBundle.pathForResource("template", ofType: "html")
        {
            htmlTemplate = String.stringWithContentsOfFile(htmlTemplatePath, encoding: NSUTF8StringEncoding, error: &error)
        } else
        {
            htmlTemplate = "";
        }
        if let cssTemplatePath:String = mainBundle.pathForResource("stylesheet", ofType: "css")
        {
            cssTemplate = String.stringWithContentsOfFile(cssTemplatePath, encoding: NSUTF8StringEncoding, error: &error)
        } else
        {
            cssTemplate = "";
        }
        
        
        channelDelegate = FTUIChannelDelegate();
        outlineDataSource = FTUIOutlineViewDataSource();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(){
        splitView = NSSplitView();
        tableView = NSTableView();
        tableContainer = NSScrollView();
        webContainer = NSScrollView();
        outlineView = NSOutlineView();
        newTableContainer = NSScrollView();
        webView = WebView();
        treeArray = [];
        loaders = [];
        urls = [];
        channelDelegate = FTUIChannelDelegate();
        outlineDataSource = FTUIOutlineViewDataSource();
        super.init();
    }
    
    override func loadView()
    {
        
        println("loadView");
        
        var frame = NSScreen.mainScreen().frame;
        self.view = NSView(frame:frame);
        
        
        var outlineFrame:CGRect = CGRect();
        var remainingFrame:CGRect = CGRect();
        CGRectDivide(frame, &outlineFrame, &remainingFrame, 150, CGRectEdge.MinXEdge);
        
        let column:NSTableColumn = NSTableColumn(identifier:"1");
        
        
        // outline view
        newTableContainer.frame = outlineFrame;
        newTableContainer.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable;
        
        
        outlineFrame.origin.y = -outlineFrame.origin.y;
        outlineView.frame = outlineFrame;
        
        
        outlineDataSource.data = treeArray;
        outlineView.setDataSource(outlineDataSource);
        outlineView.setDelegate(self);
        
        // set the first column's cells as `ImageAndTextCell`s
        var iatc:FTImageAndTextCell = FTImageAndTextCell();
        iatc.editable = false;

        newTableContainer.documentView = outlineView;

        outlineView.addTableColumn(column);
        outlineView.intercellSpacing = NSSizeFromCGSize(CGSizeMake(0, 0));
        (outlineView.tableColumns[0] as NSTableColumn).identifier = "name";
        (outlineView.tableColumns[0] as NSTableColumn).dataCell = iatc;
        
        
        
        
        
        // table view
        
        tableContainer.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;

        tableView.frame = tableContainer.frame;
        tableView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;

        tableView.allowsEmptySelection = false;
        tableView.allowsMultipleSelection = false;
        tableView.addTableColumn(column);
        tableView.intercellSpacing = NSSizeFromCGSize(CGSizeMake(1.0, 20.0));
        tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.None;
        

        tableContainer.documentView = tableView;
        tableView.backgroundColor = NSColor(calibratedRed: 173/255.0, green: 178/255.0, blue: 187/255.0, alpha: 1);
            
        tableView.target = self;
        tableView.doubleAction = Selector("doubleClickOnRssItem");
        
        
        // web view
        
        webContainer.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;
        webView.frame = webContainer.frame;
        webView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;
        
        webView.policyDelegate = self;
        webContainer.documentView = webView;

        
        tableView.reloadData();
        

        
        splitView.frame = frame;
        splitView.delegate = self;
        splitView.vertical = true;
        splitView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;

        splitView.addSubview(newTableContainer);
        splitView.addSubview(tableContainer);
        splitView.addSubview(webContainer);
        splitView.dividerStyle = NSSplitViewDividerStyle.Thin;
        splitView.adjustSubviews();
        splitView.setPosition(outlineFrame.size.width, ofDividerAtIndex: 0);
        splitView.setPosition((remainingFrame.origin.x + remainingFrame.size.width/2), ofDividerAtIndex:1);
        
        self.view.addSubview(splitView);
        
        
        
        
        let center:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        
        
        let completionBlock: (NSNotification!) -> Void = { notification in
            var item:FTRSSItem = notification.object as FTRSSItem;
            self.loadWebView(item);
        };
        
        center.addObserverForName("rssItemClicked", object: nil, queue: nil, usingBlock: completionBlock);

        
        self.webView.frameLoadDelegate = self;
        
        let loadingCompletionBlock: (NSNotification!) -> Void = { notification in
            self.outlineView.reloadData();
        };
        
        center.addObserverForName("loading updated", object: nil, queue: nil, usingBlock:loadingCompletionBlock);


    }
    
    
    
    /*******************************************************
    *
    * OUTLINE-VIEW DELEGATE
    *
    *******************************************************/
    
    
    func outlineView(outlineView: NSOutlineView!, shouldSelectItem item: AnyObject!) -> Bool
    {
        return true;
    }
    
    func outlineView(outlineView: NSOutlineView!, isGroupItem item: AnyObject!) -> Bool
    {
        return false;
    }

    func outlineViewSelectionDidChange(notification: NSNotification!)
    {
        var selected = self.outlineView.selectedRow;
        if (selected > -1)
        {
            var loader = loaders[selected];
            channelDelegate.rssItems = loader.rssItems;
            channelDelegate.feedItem = loader.rssFeed;
            
            tableView.scrollToBeginningOfDocument(tableView);

            tableView.setDataSource(channelDelegate);
            tableView.setDelegate(channelDelegate)
            
            tableView.reloadData();
        }
    }
    
    func outlineView(outlineView: NSOutlineView!, willDisplayCell cell: AnyObject!, forTableColumn tableColumn: NSTableColumn!, item: AnyObject!)
    {
        (cell as NSTextFieldCell).drawsBackground = true;
        (cell as NSTextFieldCell).textColor = NSColor.blackColor();
    }
    
        
    /*******************************************************
    *
    * SPLIT-VIEW DELEGATE
    *
    *******************************************************/

    func splitView(splitView: NSSplitView!, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat
    {
        
        if (dividerIndex == 0)
        {
            return proposedMinimumPosition + 50;
        }
        return proposedMinimumPosition + 200;

    }
        
      
    func splitView(splitView: NSSplitView!, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat
    {
        return proposedMaximumPosition - 100;
    }
    
        
        
    /*******************************************************
    *
    * TABLE VIEW DATA SOURCE
    *
    *******************************************************/

    func numberOfRowsInTableView(tableView: NSTableView!) -> Int
    {
        return urls.count;
        
    }
    
    /*******************************************************
    *
    * TABLE VIEW DELEGATE
    *
    *******************************************************/

    
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!
    {
        return urls[row].title;
    }
    
    
    
    /*******************************************************
    *
    * WEB VIEW DELEGATE
    *
    *******************************************************/

    func loadWebView(item:FTRSSItem)
    {
        var htmlText:String = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\" />";
        
        if (cssTemplate)
        {
            htmlText += "<style type=\"text/css\">";
            htmlText += cssTemplate!;
            htmlText += "</style>";
        }
        
        htmlText += "<meta http-equiv=\"Pragma\" content=\"no-cache\">";
        htmlText += "</head><body>";
        
        
        var htmlArticle = htmlTemplate!.stringByReplacingOccurrencesOfString("$ArticleLink$", withString: item.link);
        htmlArticle = htmlArticle.stringByReplacingOccurrencesOfString("$ArticleTitle$", withString: item.title);
        htmlArticle = htmlArticle.stringByReplacingOccurrencesOfString("$ArticleDate$", withString: item.pubDate);
        htmlArticle = htmlArticle.stringByReplacingOccurrencesOfString("$ArticleBody$", withString: item.description);
        
        
        var selectedRow = outlineView.selectedRow;
        if (selectedRow > -1)
        {
            var loader = loaders[selectedRow];
            htmlArticle = htmlArticle.stringByReplacingOccurrencesOfString("$FeedTitle$", withString: loader.rssFeed.title);
        }
        
        htmlText += "\(htmlArticle)";
        htmlText += "</body></html>";
        
        self.webView.mainFrame.loadHTMLString(htmlText, baseURL: NSURL.URLWithString(item.link));

    }
    
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!)
    {
        var scrollView = webView.mainFrame.frameView.documentView.enclosingScrollView;
        
//        scrollView.verticalScroller.controlSize = NSControlSize.SmallControlSize;
//        scrollView!.horizontalScroller.controlSize = NSControlSize.SmallControlSize;

    }
    
    override func webView(webView: WebView!, decidePolicyForNavigationAction actionInformation: NSDictionary!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
    {
        
        
        var actionNumber = actionInformation.objectForKey(WebActionNavigationTypeKey) as NSNumber;
        
        WebNavigationType.LinkClicked
        
        if ( actionNumber.integerValue == 0 )
        {
            listener.ignore();
            NSWorkspace.sharedWorkspace().openURL(request.URL);
        }
        else
        {
            listener.use();
        }

    }
    
    func doubleClickOnRssItem()
    {
        var item = channelDelegate.rssItems[tableView.clickedRow];
        var url:NSURL = NSURL.URLWithString(item.link);
        var sharedWorkspace:NSWorkspace = NSWorkspace.sharedWorkspace();
//        var error:NSError?;
//        var dictionary:NSDictionary = NSDictionary();
        sharedWorkspace.openURL(url);
//        , options: NSWorkspaceLaunchOptions.WithoutActivation, configuration: dictionary, error: &error);
    }
    
    


}