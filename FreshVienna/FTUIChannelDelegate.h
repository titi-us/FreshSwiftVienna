//
//  FTUIChannelDelegate.h
//  FreshVienna
//
//  Created by Thibaut on 5/11/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTUIChannelDelegate : NSObject<NSTableViewDataSource, NSTableViewDelegate>
{
}
@property(weak) NSArray *rssItems;

@end
