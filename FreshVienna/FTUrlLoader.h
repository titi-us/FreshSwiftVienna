//
//  FTUrlLoader.h
//  FreshVienna
//
//  Created by Thibaut on 5/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTRSSChannelAttributes.h"

@interface FTUrlLoader : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>
{
    FTRSSChannelAttributes *channelAttributes;
    NSMutableArray *rssItems;
}

- (id)initWithUrl:(NSString *)urlString;

@property (nonatomic, retain) FTRSSChannelAttributes *channelAttributes;
@property (nonatomic, retain) NSMutableArray *rssItems;

@end
