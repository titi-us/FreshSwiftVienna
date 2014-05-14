//
//  FTOPMLItem.h
//  FreshVienna
//
//  Created by Thibaut on 5/14/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTOPMLItem : NSObject
{
    NSString *xmlUrl;
    NSString *title;
}


@property(nonatomic, retain) NSString *xmlUrl;
@property(nonatomic, retain) NSString *title;

@end
