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
    NSString *title;
    NSString *link; // Full Content
    NSString *comments;
    NSString *description; // Short content to be displayed
    NSString *pubDate;
    NSString *guid;
    NSString *author;
    NSURL *imageUrl;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* link;
@property (nonatomic, retain) NSString* comments;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* pubDate;
@property (nonatomic, retain) NSString* guid;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSURL* imageUrl;

@end
