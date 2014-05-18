//
//  FTOPMLReader.m
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTOPMLReader.h"
#import "FTOPMLItem.h"
@interface FTOPMLReader()
{
    NSMutableArray *loadedUrls;
}
@end

@implementation FTOPMLReader

-(NSArray*)loadUrl:(NSString*)url
{
    loadedUrls = [NSMutableArray array];
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url]];
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    // now parse the document
    [xmlparser parse];
    xmlparser = nil;
    return loadedUrls;
}


#pragma mark XML Parser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // add code here to load any data members
    // that your custom class might have
    
    if (attributeDict != nil)
    {
        if ([attributeDict objectForKey:@"xmlUrl"])
        {
            FTOPMLItem *item = [[FTOPMLItem alloc] init];
            item.xmlUrl = [attributeDict objectForKey:@"xmlUrl"];
            item.title = [attributeDict objectForKey:@"text"] ? [attributeDict objectForKey:@"text"] : item.xmlUrl;
            [loadedUrls addObject:item];
        }
    }
    
}



// error handling
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}


@end
