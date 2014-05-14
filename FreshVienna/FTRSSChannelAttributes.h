//
//  FTRSSChannelAttributes.h
//  FreshVienna
//
//  Created by Thibaut on 5/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTRSSChannelAttributes : NSObject
{
    NSString *title;
    NSString *link;
    NSString *description;
    NSString *language;
    NSString *copyright;
    NSString *lastBuildDate;
    NSString *generator;
    NSString *docs;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *copyright;
@property (nonatomic, retain) NSString *lastBuildDate;
@property (nonatomic, retain) NSString *generator;
@property (nonatomic, retain) NSString *docs;

@end
