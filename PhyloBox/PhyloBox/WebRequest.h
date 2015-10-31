//
//  WebRequest.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Card.h"


@interface WebRequest : NSObject


+ (NSString *)stringWithUrl:(NSURL *)url;
//+ (NSArray *)fetchedData:(NSData *)responseData; //error:(NSError **)error;

+ (Card *) fetchData: (NSString *)JSON
            andIndex: (int) index;

@end
