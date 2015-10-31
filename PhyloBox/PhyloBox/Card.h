//
//  Card.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property NSString * Name;
@property NSString * CardURL;
@property NSString * LatinName;

@property NSString * GraphicArtist;
@property NSString * GraphicArtistURL;
@property NSString * Graphic;

@property NSString * PhotoArtist;
@property NSString * PhotoArtistURL;
@property NSString * Photo;

@property NSString * Food;
@property NSString * Hierarchy;
@property NSString * sSize;


@property NSString * Habitat1;
@property NSString * Habitat2;
@property NSString * Habitat3;

@property NSString * CardColor;
@property NSString * Temperature;
@property NSString * CardContent;

@property NSString * BackgroundImageURL;
@property NSString * SizeImageURL;
@property NSString * FoodHierarchyImageURL;

@property NSString * Classification;

@property NSString * URLresult;
@property int CardIndex;

//@property UIImage * graphicImage;
//@property UIImage * backgroundImage;
//@property UIImage * sizeImage;
//@property UIImage * foodHierarchyImage;


- (instancetype)initWithInfo: (NSString*) urlresult
                     andname: (NSString*) name
                  andcardurl: (NSString*) cardurl
                andlatinname: (NSString *) latinname

            andgraphicartist: (NSString *) graphicartist
         andgraphicartisturl: (NSString *) graphicartisturl
                  andgraphic: (NSString *) graphic

              andphotoartist: (NSString *) photoartist
           andphotoartisturl: (NSString *) photoartisturl
                    andphoto: (NSString *) photo

                     andfood: (NSString *) food
                andhierarchy: (NSString *) hierarchy
                     andsize: (NSString *) size

                  andterrain: (NSString *) habitat1
                  andterrain: (NSString *) habitat2
                  andterrain: (NSString *) habitat3

                andcardcolor: (NSString *) cardcolor
              andtemperature: (NSString*) temperature
                     andtext: (NSString *) cardContent

       andbackgroundimageurl: (NSString *) backgroundimageurl
             andsizeimageurl: (NSString *) sizeimageurl
    andfoodhierarchyimageurl: (NSString *) foodhierarchyimageurl
           andclassification: (NSString *) classification
                andcardindex: (int) cardindex;
;



typedef enum
{
    HOT,
    COLD,
    COOL,
    WARM,
}CLIMATE;

typedef enum
{
    FOREST,
    DESERT,
    FRESHWATER,
    OCEAN,
    GRASSLAND,
    TUNDRA,
    URBAN,
}TERRAIN;
@end
