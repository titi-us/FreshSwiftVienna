//
//  FTUIArticleCellView.h
//  FreshVienna
//
//  Created by Thibaut on 5/14/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FTUIArticleCellView : NSTableCellView <NSImageDelegate>
{
}

-(void)setImageUrl:(NSURL*)value;
-(void)setTitle:(NSString*)value;
-(void)setDescription:(NSString*)value;
-(void)setAuthor:(NSString*)value;
-(void)setPubDate:(NSString*)value;


@end
