//
//  ViewController.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-28.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import <dispatch/dispatch.h>
#import "SearchTableViewController.h"
#import "passCardIndex.h"


@interface ViewController : UIViewController <UIGestureRecognizerDelegate, passCardIndex,UIDocumentInteractionControllerDelegate>
{
    IBOutlet UIImageView *picCardBackground;
    IBOutlet UIImageView * picCardGraphic;
    IBOutlet UIImageView *picCardSize;
    IBOutlet UIImageView *picCardHierarchy;
    
    
    //IBOutlet UILabel *lblCardContent;
    IBOutlet UILabel *lblCardName;
    IBOutlet UILabel *lblCardLatinName;
    IBOutlet UILabel *lblCardTemperature;
    IBOutlet UITextView *lblCardContent;
    
    
    IBOutlet UIView *viewCard;
    
    UISwipeGestureRecognizer * swipeLeft;
    UISwipeGestureRecognizer * swipeRight;
    
    
    IBOutlet UISlider *slideCard;
    
    
    NSTimer * timerUpdateCard;
    
    
    IBOutlet UISegmentedControl *btnViewFav;
    
    
    IBOutlet UIBarButtonItem *btnFav;
    
    NSMutableArray * favCards;
    
}
- (IBAction)sliderDoneDrag:(id)sender;
- (IBAction)btnShareClick:(id)sender;

- (IBAction)btnGotoCardWebClicked:(id)sender;



//- (IBAction)sliderSlided:(id)sender;


//- (IBAction)btnRandomCardClick:(id)sender;

- (IBAction)btnViewFavClick:(id)sender;
- (IBAction)btnFavClick:(id)sender;


- (void) transitionToNewImage: (UIImageView*) imageView
                  andnewimage: (UIImage *) newimage;
- (void) checkFile;
- (void)downloadCardsAndSaveToFileWithStartIndex:(int)startIndex;
- (void) putCardOnViewFromFileWithCard: (Card *)card
                      isTurningRight: (BOOL) turnRight;
- (void) transitionToNewString: (UILabel *) labelView
                  andnewstring: (NSString *) newString;

- (void) updateFileWithCard: (Card*) card
           andDownloadIndex: (int) index;

+ (Card*) readCardFromFileWithIndex: (int) index;
- (void) animation: (NSString *) cardfile
           andCard: (Card *)card;
- (void) updateCards;

- (void) swipeCardToLeft;
- (void) swipeCardToRight;

+ (int) getMaxCardIndex;
//- (void) setCardIndexTo: (int) index;
- (void) timerUpdateCardTick;
- (void) checkForFirstCard;
- (int) getRandomCardIndex;

- (BOOL) isContainCard: (Card*) card;
- (void) removeCardFromFav: (Card *) card;
- (void) writeFavCardArrayToFile;
- (void) addCardToFav: (Card *) card;
- (void) readFavCardArrayFromFile;




@end
