//
//  FTUIArticleCellView.m
//  FreshVienna
//
//  Created by Thibaut on 5/14/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import "FTUIArticleCellView.h"

@interface FTUIArticleCellView()
{
    NSTextField *titleTextfield;
    NSImageView *myImageView;
    
    NSTextField *descriptionTextfield;
    NSTextField *authorTextfield;
    NSTextField *dateTextfield;
}

@property(nonatomic, retain) NSTextField *titleTextfield;
@property(nonatomic, retain) NSImageView *myImageView;


@property(nonatomic, retain) NSTextField *descriptionTextfield;
@property(nonatomic, retain) NSTextField *authorTextfield;
@property(nonatomic, retain) NSTextField *dateTextfield;



- (void)initCell;


@end

@implementation FTUIArticleCellView

@synthesize descriptionTextfield, authorTextfield, dateTextfield, titleTextfield, myImageView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCell];
        // Initialization code here.
    }
    return self;
}

-(BOOL)isFlipped
{
    return YES;
}


- (void)initCell
{
 
    self.myImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
    self.titleTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(10, 210, self.bounds.size.width - 20, 40)];

    //self.descriptionTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(0, 240, self.bounds.size.width, 40)];
    self.authorTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(0, 280, self.bounds.size.width/2, 40)];
    self.dateTextfield = [[NSTextField alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 280, self.bounds.size.width/2, 40)];
    
    [self setupTextField:self.titleTextfield];
    [self setupTextField:self.descriptionTextfield];
    [self setupTextField:self.authorTextfield];
    [self setupTextField:self.dateTextfield];
    [self.titleTextfield setFont:[NSFont boldSystemFontOfSize:15]];
    
    
    [self.dateTextfield setTextColor:[NSColor colorWithCalibratedRed:173/255.0 green:178/255.0 blue:187/255.0 alpha:1]];
    
    [self addSubview:self.myImageView];
    
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

-(void)setImageUrl:(NSURL*)value
{
    if (value != nil)
    {
        [self.myImageView setImage:[[NSImage alloc] initWithContentsOfURL:value]];
    } else
    {
        [self.myImageView setImage:nil];
    }
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




- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
