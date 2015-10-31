//
//  SpieceCard.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "Card.h"
typedef enum
{
    AUTOTROPHS,
    HERBIVORES,
    OMNIVORES,
    CARNIVORES,
    OTHER,
}DIET;

@interface SpieceCard : Card
{
    NSString * LatinName;
    int PointValue;
    int Scale;
    int Foodchain;
    DIET * Diet;
    NSString *Classification;
    
}



@end
