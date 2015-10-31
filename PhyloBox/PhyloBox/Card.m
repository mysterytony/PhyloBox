//
//  Card.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "Card.h"
#import "WebRequest.h"

@implementation Card

@synthesize  Name;
@synthesize CardURL;
@synthesize LatinName;
@synthesize GraphicArtist;
@synthesize GraphicArtistURL;
@synthesize Graphic;

@synthesize PhotoArtist;
@synthesize PhotoArtistURL;
@synthesize Photo;

@synthesize Food;
@synthesize Hierarchy;
@synthesize sSize;


@synthesize Habitat1;
@synthesize Habitat2;
@synthesize Habitat3;

@synthesize CardColor;

@synthesize Temperature;
@synthesize CardContent;

@synthesize BackgroundImageURL;
@synthesize SizeImageURL;
@synthesize FoodHierarchyImageURL;

@synthesize Classification, URLresult,CardIndex;






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
                andcardindex:(int)cardindex

{
    self = [super init];
    
    if (self) {
        
        URLresult = urlresult;
        
        Name = name;
        CardURL = cardurl;
        LatinName = latinname;
        
        GraphicArtist = graphicartist;
        GraphicArtistURL = graphicartisturl;
        Graphic = graphic;
        
        PhotoArtist = photoartist;
        PhotoArtistURL = photoartisturl;
        Photo = photo;
        
        Food = food;
        Hierarchy = hierarchy;
        sSize = size;
        
        Habitat1 = habitat1;
        Habitat2 = habitat2;
        Habitat3 = habitat3;
        
        CardColor = cardcolor;
        Temperature = temperature;///
        CardContent = cardContent;
        
        BackgroundImageURL = backgroundimageurl;
        SizeImageURL = sizeimageurl;
        FoodHierarchyImageURL = foodhierarchyimageurl;
        
        Classification = classification;
        
        
        
        
        
        
        
        CardURL = [CardURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        GraphicArtistURL = [GraphicArtistURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        Graphic = [Graphic stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        PhotoArtistURL = [PhotoArtistURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        Photo = [Photo stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        BackgroundImageURL = [BackgroundImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        SizeImageURL = [SizeImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        FoodHierarchyImageURL = [FoodHierarchyImageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        
        //reformat card_content
        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"<br>"];
        
        CardContent = [self unicodeReplacing:CardContent];
        Name = [self unicodeReplacing:Name];
        LatinName = [self unicodeReplacing:LatinName];

        
//        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"\\u2022" withString:@"&#8226;"];
//        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"\\u00a0" withString:@"&#160;"];
//        Name = [Name stringByReplacingOccurrencesOfString:@"\\u03bb" withString:@"&#955"];
//        CardContent = [CardContent stringByReplacingOccurrencesOfString:@"&bull;" withString:@""];
        
        
        
        
        
        
        
        
        
        
        CardIndex = cardindex;
    }
    
    
    return self;
}


- (NSString *) unicodeReplacing: (NSString *) str
{
    for (int i=0; i<str.length; ++i) {
        @autoreleasepool {
            
            if ([str characterAtIndex:i] == '\\' && (i+5) <= str.length)
            {
                NSString * temp = [NSString stringWithString:[str substringWithRange:NSMakeRange(i, 6)]];
                
                
                unsigned result = 0;
                NSScanner *scanner = [NSScanner scannerWithString:temp];
                
                [scanner setScanLocation:2]; // bypass '#' character
                [scanner scanHexInt:&result];
                
                NSString * temp2 = [NSString stringWithFormat:@"&#%i;", result];
                
                str = [str stringByReplacingOccurrencesOfString:temp withString: temp2];
                
            }
        }
        
    }
    return str;
}






@end













