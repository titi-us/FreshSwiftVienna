//
//  FTRSSItemAttributes.h
//  FreshVienna
//
//  Created by Thibaut on 5/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTRSSItemAttributes : NSObject
{
}

@property NSString* title;
@property NSString* link;
@property NSString* comments;
@property NSString* description;
@property NSString* pubDate;
@property NSString* guid;
@property NSString* author;
@property(nonatomic) NSURL* imageUrl;

@end
