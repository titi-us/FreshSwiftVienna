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
    NSImage *myImage;
}

@property NSTextField *titleTextfield;
@property NSImageView *myImageView;
@property NSTextField *descriptionTextfield;
@property NSTextField *authorTextfield;
@property NSTextField *dateTextfield;

- (void)initCell;
+(NSImage*)scaleImageToFillView:(NSImageView*)imageView fromImage:(NSImage*)image;

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
        if (myImage)
        {
            myImage = nil;
        }
        myImage = [[NSImage alloc] initByReferencingURL:value];
        NSImage*  targetImage = [FTUIArticleCellView scaleImageToFillView:self.myImageView fromImage:myImage];
        myImage = targetImage;
        [self.myImageView setImage:myImage];

    } else
    {
        myImage = nil;
        [self.myImageView setImage:nil];
    }
}

+(NSImage*)scaleImageToFillView:(NSImageView*)imageView fromImage:(NSImage*)image
{
    NSImage*  targetImage = [[NSImage alloc] initWithSize:imageView.frame.size];
    
    NSSize imageSize = [image size];
    NSSize imageViewSize = imageView.frame.size; // Yes, do not use dstRect.
    
    
    NSSize newImageSize = [image size];
    
    CGFloat imageAspectRatio = imageSize.height/imageSize.width;
    CGFloat imageViewAspectRatio = imageViewSize.height/imageViewSize.width;
    
    if (imageAspectRatio < imageViewAspectRatio) {
        // Image is more horizontal than the view. Image left and right borders need to be cropped.
        newImageSize.width = imageSize.height / imageViewAspectRatio;
    }
    else {
        // Image is more vertical than the view. Image top and bottom borders need to be cropped.
        newImageSize.height = imageSize.width * imageViewAspectRatio;
    }
    
    NSRect srcRect = NSMakeRect(imageSize.width/2.0-newImageSize.width/2.0,
                                imageSize.height/2.0-newImageSize.height/2.0,
                                newImageSize.width,
                                newImageSize.height);
    
    
    
    
    [targetImage lockFocus];
    
    [image drawInRect:imageView.frame // Interestingly, here needs to be dstRect and not self.bounds
               fromRect:srcRect
              operation:NSCompositeCopy
               fraction:1.0
         respectFlipped:YES
                  hints:@{NSImageHintInterpolation: @(NSImageInterpolationHigh)}];
    
    
    [targetImage unlockFocus];
    return targetImage;
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
