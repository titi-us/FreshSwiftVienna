//
//  FTUIArticleCellViewNoImageView.m
//  FreshVienna
//
//  Created by Thibaut on 5/17/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIArticleCellViewNoImageView.h"

@interface FTUIArticleCellViewNoImageView()
{
    NSTextField *titleTextfield;
    NSImageView *myImageView;
    
    NSTextField *descriptionTextfield;
    NSTextField *authorTextfield;
    NSTextField *dateTextfield;

    
}

@property(nonatomic, retain) NSTextField *titleTextfield;


@property(nonatomic, retain) NSTextField *descriptionTextfield;
@property(nonatomic, retain) NSTextField *authorTextfield;
@property(nonatomic, retain) NSTextField *dateTextfield;

- (void)initCell;

@end

@implementation FTUIArticleCellViewNoImageView

@synthesize descriptionTextfield, authorTextfield, dateTextfield, titleTextfield;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(BOOL)isFlipped
{
    return YES;
}

- (void)initCell
{
    
    self.titleTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, 70)];
    
    self.authorTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(10, 80, self.bounds.size.width/2-10, 40)];
    self.dateTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(self.bounds.size.width/2+10, 80, self.bounds.size.width/2-20, 40)];
    
    [self setupTextField:self.titleTextfield];
    [self setupTextField:self.descriptionTextfield];
    [self setupTextField:self.authorTextfield];
    [self setupTextField:self.dateTextfield];
    [self.titleTextfield setFont:[NSFont boldSystemFontOfSize:20]];
    
    
    [self.dateTextfield setTextColor:[NSColor colorWithCalibratedRed:173/255.0 green:178/255.0 blue:187/255.0 alpha:1]];
    
    
    [self setTitle:@"Title"];
    [self setDescription:@"description"];
    [self setAuthor:@"author"];
    [self setPubDate:@"date"];
    [self setAutoresizesSubviews:YES];
    
    [self setWantsLayer:YES];
    self.layer.masksToBounds   = YES;
    self.layer.borderWidth      = 1.0f ;
    
    [self.layer setBackgroundColor:CGColorGetConstantColor(kCGColorWhite)];
    [self.layer setBorderColor:CGColorGetConstantColor(kCGColorBlack)];
    
    // TODO NSBOX
    
}

-(void)setupTextField:(NSTextField*)aTextfield
{
    [aTextfield setEditable:NO];
    [aTextfield setDrawsBackground:NO];
    [aTextfield setBordered:NO];
    [self addSubview:aTextfield];
}

-(void)setTitle:(NSString*)value
{
    if (value != nil)
    {
        [self.titleTextfield setStringValue:value];
    }
}

-(void)setDescription:(NSString*)value
{
    if (value != nil)
    {
        [self.descriptionTextfield setStringValue:value];
    }
}
-(void)setAuthor:(NSString*)value
{
    if (value != nil)
    {
        [self.authorTextfield setStringValue:value];
    }
}
-(void)setPubDate:(NSString*)value
{
    if (value != nil)
    {
        [self.dateTextfield setStringValue:value];
    }
}



@end
