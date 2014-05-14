//
//  FTUrlLoader.m
//  FreshVienna
//
//  Created by Thibaut on 5/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUrlLoader.h"
#import "FTRSSItemAttributes.h"

@interface FTUrlLoader()
{
    NSMutableData *loadedData;
    BOOL hasFinishedChannel;
    NSMutableString *currentStringValue;
    FTRSSItemAttributes *currentRssItem;
}

@property (nonatomic, retain) NSMutableData *loadedData;
@property (nonatomic, retain) FTRSSItemAttributes *currentRssItem;
@end

@implementation FTUrlLoader
@synthesize loadedData, channelAttributes, rssItems, currentRssItem;



- (id)initWithUrl:(NSString *)urlString
{
    hasFinishedChannel = NO;
    rssItems = [NSMutableArray array];
    NSURL* url = [NSURL URLWithString:urlString];
    loadedData = [NSMutableData data];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    return [self init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [loadedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *rssFeedString = [[NSString alloc] initWithData:loadedData encoding:NSUTF8StringEncoding];
//    NSLog(@"Done downloading");
//    NSLog(@"%@",rssFeedString);
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithData:loadedData];
    
    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    // now parse the document
    BOOL ok = [xmlparser parse];
    if (ok == NO)
        NSLog(@"error");
    else
        NSLog(@"OK");
    
    loadedData = nil;
}



#pragma mark XML Parser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
//    NSLog(@"didStartElement: %@", elementName);
//    
//    if (namespaceURI != nil)
//        NSLog(@"namespace: %@", namespaceURI);
//    
//    if (qName != nil)
//        NSLog(@"qualifiedName: %@", qName);
//    
    // print all attributes for this element
//    NSEnumerator *attribs = [attributeDict keyEnumerator];
//    NSString *key, *value;
//    
//    while((key = [attribs nextObject]) != nil) {
//        value = [attributeDict objectForKey:key];
//        NSLog(@"  attribute: %@ = %@", key, value);
//    }
    
    // add code here to load any data members
    // that your custom class might have
    
    if ([elementName isEqualToString: @"channel"])
    {
        channelAttributes = [[FTRSSChannelAttributes alloc] init];
    }
    if ([elementName isEqualToString:@"item"])
    {
        currentRssItem = [[FTRSSItemAttributes alloc] init];
    }
    
    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] init];
    }
    [currentStringValue appendString:string];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    NSLog(@"didEndElement: %@", elementName);
    
    if (currentRssItem)
    {
        
        if ([elementName isEqualToString: @"title"])
        {
            currentRssItem.title = currentStringValue;
        } else if ([elementName isEqualToString: @"link"])
        {
            currentRssItem.link = currentStringValue;
        } else if ([elementName isEqualToString: @"description"])
        {
            currentRssItem.description = currentStringValue;
        }  else if ([elementName isEqualToString: @"comments"])
        {
            currentRssItem.comments = currentStringValue;
        } else if ([elementName isEqualToString: @"guid"])
        {
            currentRssItem.guid = currentStringValue;
        } else if ([elementName isEqualToString: @"pubDate"])
        {
            currentRssItem.pubDate = currentStringValue;
        }
        
        
        if ([elementName isEqualToString:@"item"])
        {
            [rssItems addObject:currentRssItem];
            currentRssItem = nil;
        }
    } else {
    
    
        if ([elementName isEqualToString: @"title"])
        {
            channelAttributes.title = currentStringValue;
        } else if ([elementName isEqualToString: @"link"])
        {
            channelAttributes.link = currentStringValue;
        } else if ([elementName isEqualToString: @"description"])
        {
            channelAttributes.description = currentStringValue;
        } else if ([elementName isEqualToString: @"language"])
        {
            channelAttributes.language = currentStringValue;
        } else if ([elementName isEqualToString: @"copyright"])
        {
            channelAttributes.copyright = currentStringValue;
        } else if ([elementName isEqualToString: @"lastBuildDate"])
        {
            channelAttributes.lastBuildDate = currentStringValue;
        } else if ([elementName isEqualToString: @"generator"])
        {
            channelAttributes.generator = currentStringValue;
        } else if ([elementName isEqualToString: @"docs"])
        {
            channelAttributes.docs = currentStringValue;
        }
    }
    currentStringValue = nil;

}

// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}


@end
