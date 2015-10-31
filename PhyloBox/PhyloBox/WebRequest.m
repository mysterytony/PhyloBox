//
//  WebRequest.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-29.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "WebRequest.h"
#import "Card.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation WebRequest


+ (NSString *)stringWithUrl:(NSURL *)url
{
//    NSStringRequest *urlRequest = [NSStringRequest requestWithURL:url
//                                                cachePolicy:NSStringRequestReturnCacheDataElseLoad
//                                            timeoutInterval:30];
//    // Fetch the JSON response
//    NSData *urlData;
//    NSStringResponse *response;
//    NSError *error;
//    
//    // Make synchronous request
//    urlData = [NSStringConnection sendSynchronousRequest:urlRequest
//                                    returningResponse:&response
//                                                error:&error];
//    dispatch_async(kBgQueue, ^{
//        NSData* data = [NSData dataWithContentsOfURL:
//                        url];
//        [self performSelectorOnMainThread:@selector(fetchedData:)
//                               withObject:data waitUntilDone:YES];
//    });
//    
//    
//    // Construct a String around the Data from the response
//    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

+ (Card *) fetchData: (NSString *)JSON
            andIndex: (int) index
{
    
    if ([JSON isEqualToString:@""] || [JSON isEqualToString:@"null"] || JSON == NULL) {
        return nil;
    }
    
    NSString * str = [[NSString alloc] initWithString:JSON];
    
    str = [str substringFromIndex:10];
    NSString * name = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * cardurl = tempstr;
    
    
    
    unsigned long i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    NSString * latinname = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * graphicartist = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * graphicartisturl = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * graphic = tempstr;
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    NSString * photoartist = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@"photo_artist_url"].location+19];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * photoartisturl = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * photo = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    NSString * food = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * hierarchy = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * size = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * habitat1 = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * habitat2 = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * habitat3 = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * cardcolor = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * temperature = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"card_content"].location - 3]];
    
    str = [str substringFromIndex:[str rangeOfString:@":"].location+2];
    NSString * card_content = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"\",\"background_image_url\":"].location]];
    
    
    str = [str substringFromIndex:[str rangeOfString:@"background_image_url\":"].location+23];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * backgroundimageurl = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * sizeimageurl = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+3];
    tempstr = [[NSString alloc] initWithString:[str substringToIndex:[str rangeOfString:@"\""].location]];
    NSString * foodhierarchyimageurl = tempstr;
    
    
    
    i = [str rangeOfString:@"\":"].location;
    str = [str substringFromIndex:i+2];
    NSString * classification = [NSString stringWithString:[str substringToIndex:[str rangeOfString:@"}"].location]];
    
    
    
   // NSLog(@"\n\n\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
//          name,cardurl, latinname, graphicartist, graphicartisturl, graphic, photoartist, photoartisturl, photo, food, hierarchy, size, habitat1, habitat2, habitat3, cardcolor, temperature, card_content, backgroundimageurl, sizeimageurl, foodhierarchyimageurl, classification);
    
    Card * card = [[Card alloc] initWithInfo:JSON andname: name andcardurl:cardurl andlatinname:latinname andgraphicartist:graphicartist andgraphicartisturl:graphicartisturl andgraphic:graphic andphotoartist:photoartist andphotoartisturl:photoartisturl andphoto:photo andfood:food andhierarchy:hierarchy andsize:size andterrain:habitat1 andterrain:habitat2 andterrain:habitat3 andcardcolor:cardcolor andtemperature:temperature andtext:card_content andbackgroundimageurl:backgroundimageurl andsizeimageurl:sizeimageurl andfoodhierarchyimageurl:foodhierarchyimageurl andclassification:classification andcardindex:index];
    
//    NSLog(@"%@", card.BackgroundImageURL);
    
    return card;
   
}

//+ (NSArray *)fetchedData:(NSData *)responseData /*error:(NSError **)error*/{
//    NSError *localError = nil;
//    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&localError];
//    
//    if (localError != nil) {
//        //*error = localError;
//        return nil;
//    }
//    
//    NSMutableArray *cards = [[NSMutableArray alloc] init];
//    
//    NSArray *results = [parsedObject valueForKey:@"results"];
//    NSLog(@"Count %lu", (unsigned long)results.count);
//    
//    for (NSDictionary *groupDic in results) {
//        Card *card = [[Card alloc]init];
//        
//        for (NSString *key in groupDic) {
//            if ([card respondsToSelector:NSSelectorFromString(key)]) {
//                [card setValue:[groupDic valueForKey:key] forKey:key];
//            }
//        }
//        
//        [cards addObject:card];
//    }
//    
//    return cards;
//    
//    
//    
////    //parse out the json data
////    NSError* error;
////    NSDictionary* json = [NSJSONSerialization
////                          JSONObjectWithData:responseData //1
////                          options:kNilOptions
////                          error:&error];
////    
////    NSArray* lastElement = [json objectForKey:@"loans"]; //2
////    
////    NSLog(@"loans: %@", lastElement); //3
//    
////    // 1) Get the latest loan
////    NSDictionary* loan = [lastElement objectAtIndex:0];
////    
////    // 2) Get the funded amount and loan amount
////    NSNumber* fundedAmount = [loan objectForKey:@"funded_amount"];
////    NSNumber* loanAmount = [loan objectForKey:@"loan_amount"];
////    float outstandingAmount = [loanAmount floatValue] -
////    [fundedAmount floatValue];
//    
//    // 3) Set the label appropriately
////    humanReadble.text = [NSString stringWithFormat:@"Latest loan: %@
////                         from %@ needs another $%.2f to pursue their entrepreneural dream",
////                         [loan objectForKey:@"name"],
////                         [(NSDictionary*)[loan objectForKey:@"location"]
////                          objectForKey:@"country"],
////                         outstandingAmount];
//    
//    //build an info object and convert to json
////    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
////                          [loan objectForKey:@"name"],
////                          @"who",
////                          [(NSDictionary*)[loan objectForKey:@"location"]
////                           objectForKey:@"country"],
////                          @"where",
////                          [NSNumber numberWithFloat: outstandingAmount],
////                          @"what",
////                          nil];
////    
////    //convert object to data
////    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info 
////                                                       options:NSJSONWritingPrettyPrinted error:&error];
//}


@end
