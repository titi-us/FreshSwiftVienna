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
}

- (id)initWithUrl:(NSString *)urlString;

@property FTRSSChannelAttributes *channelAttributes;
@property NSMutableArray *rssItems;

@end
