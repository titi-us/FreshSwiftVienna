//
//  FTOPMLReader.h
//  FreshVienna
//
//  Created by Thibaut on 5/13/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTOPMLReader : NSObject<NSXMLParserDelegate>

-(NSArray*)loadUrl:(NSString*)url;
@end
