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

@interface FTUIMainViewController ()
{
    // delegates
    FTUIChannelDelegate *channelDelegate;

    // data
    NSArray *urls;
    NSMutableArray *loaders;
    
    //views
    NSSplitView *splitView;
    NSTableView *tableView;
    NSScrollView *tableContainer;
    WebView *webView;
    NSScrollView *webContainer;
    NSOutlineView *outlineView;
    
    // temp views
    NSTableView *newTableView;
    NSScrollView *newTableContainer;
    
    
    // WebView HTML and CSS
    NSString *htmlTemplate;
    NSString *cssTemplate;
    

}
@property (nonatomic, retain) WebView *webView;
@property (nonatomic, retain) NSArray *urls;
@end

@implementation FTUIMainViewController
@synthesize urls, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    
    FTOPMLReader *reader = [[FTOPMLReader alloc] init];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"Test" ofType:@"opml"];

    
    self.urls = [reader loadUrl:filePath];
    
    loaders = [NSMutableArray array];
    for (FTOPMLItem* url in self.urls) {
        FTUrlLoader *urlLoader = [[FTUrlLoader alloc] initWithUrl:url.xmlUrl];
        [loaders addObject:urlLoader];
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
    
    tableContainer = [[NSScrollView alloc] init];
    [tableContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    tableView = [[NSTableView alloc] initWithFrame:tableContainer.frame];
    [tableView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    NSTableColumn *column =[[NSTableColumn alloc]initWithIdentifier:@"1"];
    [column.headerCell setTitle:@"Headline"];
    
    [tableView setAllowsEmptySelection:NO];
    [tableView setAllowsMultipleSelection:NO];
    [tableView addTableColumn:column];
    
    channelDelegate = [[FTUIChannelDelegate alloc] init];
    
    
    [tableContainer setDocumentView:tableView];

    
    splitView = [[NSSplitView alloc] initWithFrame:remainingFrame];
    [splitView setDelegate:self];
    [splitView setVertical:YES];
    [splitView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [splitView addSubview:tableContainer];

    
    webContainer = [[NSScrollView alloc] init];
    [webContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    self.webView = [[WebView alloc] initWithFrame:webContainer.frame];
    [self.webView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    [webContainer setDocumentView:webView];
    
    
    [splitView addSubview:webContainer];
    [self.view addSubview:splitView];
    [tableView reloadData];
    

    
    
    newTableContainer = [[NSScrollView alloc] initWithFrame:outlineFrame];
    [newTableContainer setAutoresizingMask: NSViewHeightSizable];
    newTableView = [[NSTableView alloc] initWithFrame:outlineFrame];

    
    
    [newTableView setAutoresizingMask:NSViewHeightSizable];
    NSTableColumn *aColumn =[[NSTableColumn alloc]initWithIdentifier:@"1"];
    [aColumn.headerCell setTitle:@"Channels"];
    
    [newTableView setAllowsEmptySelection:NO];
    [newTableView setAllowsMultipleSelection:NO];
    [newTableView addTableColumn:aColumn];

    [newTableContainer setDocumentView:newTableView];

    
    [self.view addSubview:newTableContainer];
    newTableView.dataSource = self;
    newTableView.delegate = self;
    
//    [self.view setAutoresizesSubviews:YES];
}

#pragma SplitView Delegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
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
    self.webView.frameLoadDelegate = self;
    
    
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
    htmlArticle = [htmlArticle stringByReplacingOccurrencesOfString:@"$ArticleBody$" withString:[item description]];
    
    
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


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if ([newTableView selectedRow] > -1)
    {
        FTUrlLoader *loader = [loaders objectAtIndex:[newTableView selectedRow]];
        channelDelegate.rssItems = loader.rssItems;
        
        
        [tableView setDataSource:channelDelegate];
        [tableView setDelegate:channelDelegate];
        [tableView reloadData];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:@"rssItemClicked"
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *notification)
        {
            
        
            FTRSSItemAttributes* item = notification.object;
            [self loadWebView:item];
        }];
    }
}

@end
