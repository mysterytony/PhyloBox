//
//  SearchTableViewController.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-08.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "passCardIndex.h"

//@protocol passCardIndex <NSObject>
//
//- (void) setCardIndexTo: (int) newIndex;
//
//@end

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray * cards;
@property (nonatomic, strong) NSMutableArray * results;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@property (retain) id <passCardIndex> delegate;

- (IBAction)btnCancelClick:(id)sender;
- (void) searchThroughCards;
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void) addElementWithArray: (NSMutableArray*) arr
                              andobject: (id) obj;
@end
