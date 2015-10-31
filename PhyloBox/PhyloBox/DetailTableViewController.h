//
//  DetailTableViewController.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-13.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "passCardIndex.h"




@interface DetailTableViewController : UITableViewController <UISearchBarDelegate>
{
    Card * card;
    IBOutlet UINavigationItem *lblTitle;
    
    
}

@property (nonatomic, strong) NSMutableArray * cards;
@property (nonatomic, strong) NSMutableArray * results;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;

@property (retain) id <passCardIndex> delagate;



- (IBAction)btnCancelClick:(id)sender;
- (void)receieveCard:(Card *)newcard;
- (void) searchThroughCards;
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void) addElementWithArray: (NSMutableArray *) arr
                                andobj: (id) obj;

- (BOOL) isCompatible: (Card *) othercard;
- (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//- (UIColor *)colorWithRGBHex:(UInt32)hex;
@end
