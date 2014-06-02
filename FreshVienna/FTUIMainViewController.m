//
//  FTUIMainViewController.m
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIMainViewController.h"
#import "FTUrlLoader.h"
#import "FTUIChannelDelegate.h"
#import <WebKit/WebKit.h>
#import "FTOPMLReader.h"
#import "FTOPMLItem.h"
#import "ImageAndTextCell.h"
#import "FTUIOutlineViewDataSource.h"
#import "FTUITreeItem.h"

@interface FTUIMainViewController ()
{
    // delegates
    FTUIChannelDelegate *channelDelegate;

    // data
    NSMutableArray *loaders;
    FTUIOutlineViewDataSource *outlineDataSource;
    
    
    //views
    NSSplitView *splitView;
    NSTableView *tableView;
    NSScrollView *tableContainer;
    NSScrollView *webContainer;
    NSOutlineView *outlineView;
    
    // temp views
    NSScrollView *newTableContainer;
    
    
    // WebView HTML and CSS
    NSString *htmlTemplate;
    NSString *cssTemplate;
    
    NSMutableArray *treeArray;
    
}

@property WebView *webView;
@property NSArray *urls;
@end

@implementation FTUIMainViewController
@synthesize urls, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        loaders = [NSMutableArray array];
    }
    
    
    FTOPMLReader *reader = [[FTOPMLReader alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"Test" ofType:@"opml"];

    
    self.urls = [reader loadUrl:filePath];
    
    treeArray = [NSMutableArray array];
    
    for (FTOPMLItem* url in self.urls) {
        FTUrlLoader *urlLoader = [[FTUrlLoader alloc] initWithUrl:url.xmlUrl];
        [loaders addObject:urlLoader];
        [treeArray addObject:[FTUITreeItem treeItemFromItem:url loader:urlLoader]];
    }
    
    
    
    NSError *error;
    htmlTemplate = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"template" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    
    cssTemplate = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"stylesheet" ofType:@"css"] encoding:NSUTF8StringEncoding error:&error];

    
    return self;
}

-(void)loadView
{
    
    CGRect frame = [NSScreen mainScreen].frame;
    self.view = [[NSView alloc] initWithFrame:frame];
    
    CGRect outlineFrame;
    CGRect remainingFrame;
    CGRectDivide(frame, &outlineFrame, &remainingFrame, 150, CGRectMinXEdge);
    
    
    NSTableColumn *column =[[NSTableColumn alloc]initWithIdentifier:@"1"];
    
    
    // outline view
    newTableContainer = [[NSScrollView alloc] initWithFrame:outlineFrame];
    [newTableContainer setAutoresizingMask: NSViewHeightSizable];
    
    
    
    
    
    outlineFrame.origin.y = - outlineFrame.origin.y;
    outlineView = [[NSOutlineView alloc] initWithFrame:outlineFrame];
    
    
    outlineDataSource = [[FTUIOutlineViewDataSource alloc] init];
    outlineDataSource.data = treeArray;
    
    [outlineView setDataSource:(id<NSOutlineViewDataSource>)outlineDataSource];
    [outlineView setDelegate:(id<NSOutlineViewDelegate>)self];
    
    // set the first column's cells as `ImageAndTextCell`s
    ImageAndTextCell* iatc = [[ImageAndTextCell alloc] init];
    [iatc setEditable:NO];
    
    [newTableContainer setDocumentView:outlineView];
    
    
    [outlineView addTableColumn:column];
    [outlineView setIntercellSpacing:NSMakeSize(0, 0)];
    [[[outlineView tableColumns] objectAtIndex:0] setIdentifier:@"name"];
    [[[outlineView tableColumns] objectAtIndex:0] setDataCell:iatc];
    
    
//    [self.view addSubview:newTableContainer];

    
    
    
    
    
    
    
    
    
    
    
    // table view
    
    
    tableContainer = [[NSScrollView alloc] init];
    [tableContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    tableView = [[NSTableView alloc] initWithFrame:tableContainer.frame];
    [tableView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    [tableView setAllowsEmptySelection:NO];
    [tableView setAllowsMultipleSelection:NO];
    [tableView addTableColumn:column];
    [tableView setIntercellSpacing:NSSizeFromCGSize(CGSizeMake(1.0, 20.0))];
    [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
                                    
                                    
    channelDelegate = [[FTUIChannelDelegate alloc] init];
    
    
    [tableContainer setDocumentView:tableView];
    tableView.backgroundColor = [NSColor colorWithCalibratedRed:173/255.0 green:178/255.0 blue:187/255.0 alpha:1];
    
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(doubleClickOnRssItem:)];
    
    
    
    
    
    // web view
    
    
    webContainer = [[NSScrollView alloc] init];
    [webContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    self.webView = [[WebView alloc] initWithFrame:webContainer.frame];
    [self.webView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    
    [self.webView setPolicyDelegate:self];
    
    [webContainer setDocumentView:webView];
    [tableView reloadData];
    
    
    
    splitView = [[NSSplitView alloc] initWithFrame:frame];
    [splitView setDelegate:self];
    [splitView setVertical:YES];
    [splitView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [splitView addSubview:newTableContainer];
    [splitView addSubview:tableContainer];
    [splitView addSubview:webContainer];
    [splitView setDividerStyle:NSSplitViewDividerStyleThin];
    [splitView adjustSubviews];
    [splitView setPosition:outlineFrame.size.width ofDividerAtIndex:0];
    [splitView setPosition:(remainingFrame.origin.x + remainingFrame.size.width/2) ofDividerAtIndex:1];

    [self.view addSubview:splitView];
    

    
    

    
    
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:@"rssItemClicked"
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *notification)
     {
         
         
         FTRSSItemAttributes* item = notification.object;
         [self loadWebView:item];
     }];

    self.webView.frameLoadDelegate = self;
    
    [center addObserverForName:@"loading updated" object:nil queue:nil usingBlock:^(NSNotification *notification)
    {
        [outlineView reloadData];
    }];
}






/*******************************************************
 *
 * OUTLINE-VIEW DELEGATE
 *
 *******************************************************/

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return NO;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selected = [outlineView selectedRow];
    if (selected > -1)
    {
        FTUrlLoader *loader = [loaders objectAtIndex:selected];
        channelDelegate.rssItems = loader.rssItems;
        channelDelegate.feedItem = loader.channelAttributes;
        
        [tableView scrollToBeginningOfDocument:tableView];
        
        if (tableView.dataSource != channelDelegate)
        {
            [tableView setDataSource:channelDelegate];
            [tableView setDelegate:channelDelegate];
        }
        [tableView reloadData];
        
    }

}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    [cell setDrawsBackground:YES];
    [cell setTextColor:[NSColor blackColor]];
    
}

































#pragma SplitView Delegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
    if (dividerIndex == 0)
    {
        return proposedMinimumPosition + 50;
    }
    return proposedMinimumPosition + 200;
}
/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
    return proposedMaximumPosition - 100;
}


#pragma TableDataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.urls.count;
}


#pragma TableView Delegate
// cell based
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return ((FTOPMLItem*)[self.urls objectAtIndex:rowIndex]).title;
}


- (void)loadWebView:(FTRSSItemAttributes*)item
{
    
    NSMutableString * htmlText = [[NSMutableString alloc] initWithString:@"<!DOCTYPE html><html><head><meta charset=\"UTF-8\" />"];
	if (cssTemplate != nil)
	{
		[htmlText appendString:@"<style type=\"text/css\">"];
		[htmlText appendString:cssTemplate];
		[htmlText appendString:@"</style>"];
	}

	[htmlText appendString:@"<meta http-equiv=\"Pragma\" content=\"no-cache\">"];
	[htmlText appendString:@"</head><body>"];
		
    // Load the selected HTML template for the current view style and plug in the current
    // article values and style sheet setting.
    NSString * htmlArticle;
    htmlArticle = [htmlTemplate stringByReplacingOccurrencesOfString:@"$ArticleLink$" withString:[item link]];
    htmlArticle = [htmlArticle stringByReplacingOccurrencesOfString:@"$ArticleTitle$" withString:[item title]];
    htmlArticle = [htmlArticle stringByReplacingOccurrencesOfString:@"$ArticleDate$" withString:[item pubDate]];
    htmlArticle = [htmlArticle stringByReplacingOccurrencesOfString:@"$ArticleBody$" withString:[item description]];
    
    
    NSInteger selected = [outlineView selectedRow];
    if (selected > -1)
    {
        FTUrlLoader *loader = [loaders objectAtIndex:selected];
        htmlArticle = [htmlArticle stringByReplacingOccurrencesOfString:@"$FeedTitle$" withString:[loader.channelAttributes title]];
    }
    
    [htmlText appendString:htmlArticle];
	[htmlText appendString:@"</body></html>"];
    
    [self.webView.mainFrame loadHTMLString:htmlText baseURL:[NSURL URLWithString:item.link]];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    //get the scroll view that contains the frame contents
    NSScrollView* scrollView = [[[[webView mainFrame] frameView] documentView] enclosingScrollView];
    [[scrollView verticalScroller] setControlSize: NSSmallControlSize];
    [[scrollView horizontalScroller] setControlSize: NSSmallControlSize];
}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id <WebPolicyDecisionListener>)listener
{
    if ([[actionInformation objectForKey:WebActionNavigationTypeKey] intValue]  == WebNavigationTypeLinkClicked) {
        [listener ignore];
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    }
    else
        [listener use];
}




-(void)doubleClickOnRssItem:(id)object
{
    FTRSSItemAttributes* item = [channelDelegate.rssItems objectAtIndex:[tableView clickedRow]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:item.link]];

}

@end
