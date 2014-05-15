//
//  FTRSSItemAttributes.m
//  FreshVienna
//
//  Created by Thibaut on 5/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTRSSItemAttributes.h"

@implementation FTRSSItemAttributes
@synthesize title, link, comments, description, guid, pubDate,author,imageUrl;

-(NSURL*)imageUrl
{
    if (self.description)
    {
        NSError *error = NULL;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                                   error:&error];
        

        NSArray *matches = [detector matchesInString:self.description
                                             options:0
                                               range:NSMakeRange(0, [self.description length])];
        for (NSTextCheckingResult *match in matches) {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                if ([url.path hasSuffix:@"jpg"] || [url.path hasSuffix:@"png"] ) // it's an image \o/
                {
                    NSLog(@"Url found -> %@", url);
                    return url;
                }
            }
        }

    }
    return nil;
}

@end
