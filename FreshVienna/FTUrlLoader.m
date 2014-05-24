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
    NSMutableString *currentStringValue;
}

@property NSMutableData *loadedData;
@property FTRSSItemAttributes *currentRssItem;
@end

@implementation FTUrlLoader
@synthesize loadedData, channelAttributes, rssItems, currentRssItem;



- (id)initWithUrl:(NSString *)urlString
{
    rssItems = [NSMutableArray array];
    NSURL* url = [NSURL URLWithString:urlString];
    loadedData = [NSMutableData data];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    self.isLoading = YES;
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
    currentStringValue = nil;
    currentRssItem = nil;
    
    self.isLoading = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loading updated" object:self];
    
}



#pragma mark XML Parser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    
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
            currentRssItem.title = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"link"])
        {
            currentRssItem.link = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"description"])
        {
            currentRssItem.description = currentStringValue;
        }  else if ([elementName isEqualToString: @"comments"])
        {
            currentRssItem.comments = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"guid"])
        {
            currentRssItem.guid = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"pubDate"])
        {
            currentRssItem.pubDate = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSDate *pubDate = [NSDate dateWithNaturalLanguageString:currentRssItem.pubDate];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
            NSDate *today = [cal dateFromComponents:components];
            components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:pubDate];
            NSDate *otherDate = [cal dateFromComponents:components];
            
            if([today isEqualToDate:otherDate]) {
                self.unreadCount += 1;
            }
        }
        
        
        if ([elementName isEqualToString:@"item"])
        {
            [rssItems addObject:currentRssItem];
            currentRssItem = nil;
        }
    } else {
    
    
        if ([elementName isEqualToString: @"title"])
        {
            channelAttributes.title = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"link"])
        {
            channelAttributes.link = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([elementName isEqualToString: @"description"])
        {
            channelAttributes.description = [currentStringValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
