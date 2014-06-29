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

class FTUIMainViewController : NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSOutlineViewDelegate
{
    
    // delegates
    var channelDelegate:FTUIChannelDelegate;
    var webViewDelegate:FTUIWebViewDelegate;
    var splitViewDelegate:FTUISplitViewDelegate;
    
    // data
    var urls:FTOPMLItem[];
    var loaders:FTURLLoader[];
    var outlineDataSource:FTUIOutlineViewDataSource;
    var treeArray:FTUITreeItem[];
    let queue:NSOperationQueue;
    
    //views
    var splitView:NSSplitView;
    var tableView:NSTableView;
    var tableContainer:NSScrollView;
    var webView:WebView;
    var webContainer:NSScrollView;
    var outlineView:NSOutlineView;
    var outlineContainer:NSScrollView;
    
    // WebView HTML and CSS
    var htmlTemplate:String?;
    var cssTemplate:String?;
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        splitView = NSSplitView();
        tableView = NSTableView();
        tableContainer = NSScrollView();
        webContainer = NSScrollView();
        outlineView = NSOutlineView();
        outlineContainer = NSScrollView();
        webView = WebView();
        treeArray = [];
        loaders = [];
        urls = [];
        queue = NSOperationQueue();
        channelDelegate = FTUIChannelDelegate();
        outlineDataSource = FTUIOutlineViewDataSource();
        webViewDelegate = FTUIWebViewDelegate();
        splitViewDelegate = FTUISplitViewDelegate();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        loadRessources();
    }
    
    
    func loadRessources()
    {
        var reader:FTOPMLReader = FTOPMLReader();
        var error:NSError?;
        let mainBundle = NSBundle.mainBundle();
        
        if let filePath:String = mainBundle.pathForResource("Test", ofType: "opml")
        {
            urls = reader.loadUrl(filePath);
        }
        
//        urls = [FTOPMLItem(xmlUrl:"https://news.ycombinator.com/rss", title:"Hacker news")];
        
        
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


    }
    
    override func loadView()
    {
        
        println("loadView");
        
        var frame = NSScreen.mainScreen().frame;
        self.view = NSView(frame:frame);
        
        
        var outlineFrame:CGRect = CGRect();
        var remainingFrame:CGRect = CGRect();
        CGRectDivide(frame, &outlineFrame, &remainingFrame, 240, CGRectEdge.MinXEdge);
        
        let column:NSTableColumn = NSTableColumn(identifier:"1");

        // outline view
        setupOutlineView(&outlineFrame);
        outlineView.setDelegate(self);
        
        // set the first column's cells as `ImageAndTextCell`s
        var iatc:FTImageAndTextCell = FTImageAndTextCell();
        iatc.editable = false;

        outlineContainer.documentView = outlineView;

        outlineView.addTableColumn(column);
        outlineView.intercellSpacing = NSSizeFromCGSize(CGSizeMake(0, 0));
        (outlineView.tableColumns[0] as NSTableColumn).identifier = "name";
        (outlineView.tableColumns[0] as NSTableColumn).dataCell = iatc;
        outlineView.headerView = nil;
        
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
        webView.policyDelegate = webViewDelegate;
        webContainer.documentView = webView;

        
        tableView.reloadData();
        
        setupSplitView(frame);
        splitView.setPosition(outlineFrame.size.width, ofDividerAtIndex: 0);
        splitView.setPosition((remainingFrame.origin.x + remainingFrame.size.width/2), ofDividerAtIndex:1);

        
        self.view.addSubview(splitView);
        
        queue.maxConcurrentOperationCount = 15;
        
        for url in urls {
            var urlLoader:FTURLLoader = FTURLLoader(urlPath:url.xmlUrl);
            loaders.append(urlLoader);
            var asyncLoadOperation = FTURLOperation(loader: urlLoader);
            queue.addOperation(asyncLoadOperation);
            treeArray.append(FTUITreeItem(loader: urlLoader, item: url));
        }
        
        outlineDataSource.data = treeArray;
        outlineView.setDataSource(outlineDataSource);
        
        
        let center:NSNotificationCenter = NSNotificationCenter.defaultCenter();
        
        
        let completionBlock: (NSNotification!) -> Void = { notification in
            var item:FTRSSItem = notification.object as FTRSSItem;
            self.loadWebView(item);
        };
        
        center.addObserverForName("rssItemClicked", object: nil, queue: nil, usingBlock: completionBlock);
        
        self.webView.frameLoadDelegate = self;
        self.outlineView.reloadData();

        var context:KVOContext = KVOContext();
        queue.addObserver(self, forKeyPath: "operationCount", options: NSKeyValueObservingOptions.New, kvoContext: context);

    }
    
    
    func setupSplitView(frame:CGRect)
    {
        splitView.frame = frame;
        splitView.delegate = splitViewDelegate;
        splitView.vertical = true;
        splitView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable;
        
        splitView.addSubview(outlineContainer);
        splitView.addSubview(tableContainer);
        splitView.addSubview(webContainer);
        splitView.dividerStyle = NSSplitViewDividerStyle.Thin;
        splitView.adjustSubviews();

    }
    
    
    func setupOutlineView(inout outlineFrame:CGRect)
    {
        outlineContainer.frame = outlineFrame;
        outlineContainer.autoresizingMask = NSAutoresizingMaskOptions.ViewHeightSizable;
        
        outlineFrame.origin.y = -outlineFrame.origin.y;
        outlineView.frame = outlineFrame;

    }
    
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: NSDictionary!, context: CMutableVoidPointer)
    {
        let queueObject = object as NSOperationQueue;
        
        if queueObject == self.queue && keyPath == "operationCount"
        {
            if self.queue.operationCount == 0
            {
                println("queue has completed");
                self.outlineView.reloadData();
            } else
            {
                println("queue not done");
            }
        } else
        {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
        }
    }
    
    

    
    
    /*******************************************************
    *
    * OUTLINE-VIEW DELEGATE
    *
    *******************************************************/
    
    func outlineView(outlineView: NSOutlineView!, heightOfRowByItem item: AnyObject!) -> CGFloat
    {
        return 23;
    }
    
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
    
    func doubleClickOnRssItem()
    {
        var item = channelDelegate.rssItems[tableView.clickedRow];
        openUrlInBackground(item.link);
    }
    
    func openUrlInBackground(urlPath:String)
    {
        var url:NSURL = NSURL.URLWithString(urlPath);
        var sharedWorkspace:NSWorkspace = NSWorkspace.sharedWorkspace();
        var options:NSWorkspaceLaunchOptions = (NSWorkspaceLaunchOptions.WithoutActivation | NSWorkspaceLaunchOptions.Default);
        sharedWorkspace.openURLs([url], withAppBundleIdentifier: nil, options: options, additionalEventParamDescriptor: nil, launchIdentifiers: nil);
    }
    


}