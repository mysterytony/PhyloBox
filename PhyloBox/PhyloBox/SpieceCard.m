//
//  SpieceCard.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "SpieceCard.h"

@implementation SpieceCard

- (instancetype) init:
(NSString*)name
andpoint:(int) pointvalue
andscale:(int) scale
andfoodchain: (int) foodchain
anddiet: (DIET*) diet
andclassification: (NSString*)classification
{
    self = [super init];
    
    LatinName = name;
    PointValue = pointvalue;
    Scale = scale;
    Foodchain = foodchain;
    Diet = diet;
    Classification = classification;
    
    return self;
}

@end
