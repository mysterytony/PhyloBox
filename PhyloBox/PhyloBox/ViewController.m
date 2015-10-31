//
//  ViewController.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-04-28.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "ViewController.h"
#import "WebRequest.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <dispatch/dispatch.h>
#import "SearchTableViewController.h"
#import "DetailTableViewController.h"
#import "CWStatusBarNotification.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WebPageViewController.h"

#import "UIAlertView+Blocks.h"

@interface ViewController ()
{
//    dispatch_queue_t queue;
    
    SystemSoundID cardFlipSoundEffectID;
}

@end



@implementation ViewController


int cardindex = 1;
int favindex = 0;
bool cardindexchanged = NO;
bool isViewFav = NO;



#pragma fav card actions

- (BOOL) isContainCard: (Card*) card
{
    return [favCards containsObject:[NSNumber numberWithInt:card.CardIndex]];
}

- (void) removeCardFromFav: (Card *) card
{
    [favCards removeObject:[NSNumber numberWithInt:card.CardIndex]];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [favCards sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    [self writeFavCardArrayToFile];
    
    if (isViewFav) {
        slideCard.maximumValue--;
    }
}




- (void) writeFavCardArrayToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *favcardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"fav.txt"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:favcardfile]) {
    [fileManager createFileAtPath:favcardfile  contents:nil attributes:nil];
//    }
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [favCards sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    NSMutableString * strwritetofile = [[NSMutableString alloc] init];
    for (NSNumber * i in favCards) {
        [strwritetofile appendString:[NSString stringWithFormat:@"%i,", i.intValue]];
    }
    
    
    [strwritetofile writeToFile:favcardfile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

- (void) addCardToFav: (Card *) card
{
    if (![favCards containsObject:card]) {
        [favCards addObject:[NSNumber numberWithInt:card.CardIndex]];
        
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [favCards sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *favcardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"fav.txt"]];
        
        NSString * writedata = [[NSString stringWithContentsOfFile:favcardfile encoding:NSUTF8StringEncoding error:nil] stringByAppendingString:[NSString stringWithFormat:@"%i,", card.CardIndex]];
        [writedata writeToFile:favcardfile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void) readFavCardArrayFromFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *favcardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"fav.txt"]];
    
    NSString * strdata = [NSString stringWithContentsOfFile:favcardfile encoding:NSUTF8StringEncoding error:nil];
    
    favCards = [NSMutableArray arrayWithArray:[strdata componentsSeparatedByString:@","]];
    
    for (int i=0; i<favCards.count; ++i) {
        if ([favCards[i] isEqualToString:@""]) {
            [favCards removeObjectAtIndex:i];
            --i;
        }
        else
        {
            favCards[i] = [NSNumber numberWithInt:((NSString *)favCards[i]).intValue];
        }
    }
    
}













#pragma swipe card actions

- (void) swipeCardToLeft
{
    Card * card;
    if (isViewFav) {
        favindex ++;
        if (favindex >= favCards.count) {
            favindex --;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Last Card" message:@"This is the last card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            card = [ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]];
            [self putCardOnViewFromFileWithCard:card isTurningRight:YES];
            slideCard.value = favindex;
        }
        
        
    }
    else
    {
        cardindex ++;
        card = [ViewController readCardFromFileWithIndex:cardindex];
        if (card == nil) {
            cardindex --;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Last Card" message:@"This is the last card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            [self putCardOnViewFromFileWithCard:card isTurningRight:YES];
            slideCard.value = cardindex;
        }
    }
    
    
    
}



- (void) swipeCardToRight
{
    Card * card;
    if (isViewFav) {
        favindex --;
        if (favindex < 0) {
            favindex ++;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"First Card" message:@"This is the first card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            card = [ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]];
            [self putCardOnViewFromFileWithCard:card isTurningRight:NO];
            slideCard.value = favindex;
        }
    }
    else
    {
        cardindex --;
        card = [ViewController readCardFromFileWithIndex:cardindex];
        if (card == nil) {
            cardindex ++;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"First Card" message:@"This is the first card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [self putCardOnViewFromFileWithCard:card isTurningRight:NO];
            slideCard.value = cardindex;
        }
    }
}











#pragma delegate action

- (void)setCardIndexTo:(int)newIndex
{
    if (isViewFav) {
        if (! [favCards containsObject:[NSNumber numberWithInt:newIndex]]) {
            cardindex = newIndex;
            [self setToViewAll];
            
        }
        else
        {
            favindex = (int)[favCards indexOfObject:[NSNumber numberWithInt:newIndex]];
            slideCard.value = favindex;
        }
        
    }
    else
    {
        cardindex = newIndex;
        slideCard.value = cardindex;
    }
    
    
    cardindexchanged = YES;
}








#pragma slider actions

- (IBAction)sliderDoneDrag:(id)sender {
//    NSLog(@"%f", slideCard.value);
    if (isViewFav && slideCard.value < 0) {
        slideCard.value = 0;
        return;
    }
    else if (isViewFav && slideCard.value >= favCards.count)
    {
        slideCard.value = favCards.count-1;
        return;
    }
    
    if (isViewFav) {
        int fileIndex = [favCards[(int)slideCard.value] intValue];
        [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:fileIndex] isTurningRight:YES];
        
    }
    else
    {
        [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:(int)slideCard.value] isTurningRight:YES];
    }
}

- (IBAction)btnShareClick:(id)sender {
//    int index = (isViewFav)? [favCards[favindex] intValue] : cardindex;
//    NSString *cardname = [ViewController readCardFromFileWithIndex:index].Name;
//    
//    NSString * strShare = [NSString stringWithFormat:@"Share your %@ Phylo Card", cardname];
    
    
    
//    __block int a = arc4random() % 99 + 1;
//    __block int b = arc4random() % 99 + 1;
//    
//    UIAlertView * alertParentalAccess = [[UIAlertView alloc] initWithTitle:@"Parental Gate" message:[NSString stringWithFormat:@"To ensure you are an adult, please answer: %i + %i", a,b] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    
//    
//    [alertParentalAccess setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    
//    UITextField * alertText = [[UITextField alloc] init];
//    
//    alertText = [alertParentalAccess textFieldAtIndex:0];
//    
//    [alertText becomeFirstResponder];
//    alertText.keyboardType = UIKeyboardTypeNumberPad;
//    alertText.placeholder = @"Enter the answer here";
//    alertText.keyboardAppearance = UIKeyboardAppearanceAlert;
//    alertText.clearsOnBeginEditing = YES;
//    alertText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    
//    alertParentalAccess.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == [alertView cancelButtonIndex]) {
//            
//        }
//        else
//        {
//            NSString *s = [[alertView textFieldAtIndex:0] text];
//            NSInteger answer = [s integerValue];
//            if (a + b != answer)
//            {
//                [UIAlertView showWithTitle:@"Sorry" message:@"It was a wrong answer" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
//                
//            }
//            else
//            {
//                
//                //action accessed
//                
//                
//                
//                
//
//                
//                
//            }
//        }
//    };
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSString *screenshot = [documentsDirectory stringByAppendingPathComponent:@"screenshot.png"];
    [fileManager createFileAtPath:screenshot contents:nil attributes:nil];
    
    UIImage * imgShare = [self screenshot];
    NSData * imageData = UIImagePNGRepresentation(imgShare);
    [imageData writeToFile:screenshot atomically:YES];
    
    
    
    NSArray * itemsToShare = @[imgShare];
    
    
    
    
    
    
    UIActivityViewController * shareVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities: nil];
    shareVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    
    
    [self presentViewController:shareVC animated:YES completion:nil];
    [shareVC setCompletionHandler:^(NSString *act, BOOL done){
        CWStatusBarNotification * completedownloadingnotification = [CWStatusBarNotification new];
        completedownloadingnotification.notificationLabelBackgroundColor = [UIColor grayColor];
        completedownloadingnotification.notificationLabelTextColor = [UIColor greenColor];
        completedownloadingnotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        completedownloadingnotification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        completedownloadingnotification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        
        
        if (done) {
            if ([act isEqualToString:UIActivityTypeSaveToCameraRoll]) {
                
                [completedownloadingnotification displayNotificationWithMessage:@"Seccessfully saved to camera roll" forDuration:0.5];
            }
        }
        else
        {
            if ([act isEqualToString:UIActivityTypeSaveToCameraRoll]) {
                [completedownloadingnotification displayNotificationWithMessage:@"Saving to camera roll was unseccessfull!" forDuration:0.5];
            }
        }
        
    }];
    
    
    }

- (IBAction)btnGotoCardWebClicked:(id)sender {

    
//    __block int a = arc4random() % 99 + 1;
//    __block int b = arc4random() % 99 + 1;
//    
//    UIAlertView * alertParentalAccess = [[UIAlertView alloc] initWithTitle:@"Parental Gate" message:[NSString stringWithFormat:@"To ensure you are an adult, please answer: %i + %i", a,b] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    
//    
//    [alertParentalAccess setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    
//    UITextField * alertText = [[UITextField alloc] init];
//    
//    alertText = [alertParentalAccess textFieldAtIndex:0];
//    
//    [alertText becomeFirstResponder];
//    alertText.keyboardType = UIKeyboardTypeNumberPad;
//    alertText.placeholder = @"Enter the answer here";
//    alertText.keyboardAppearance = UIKeyboardAppearanceAlert;
//    alertText.clearsOnBeginEditing = YES;
//    alertText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    
//    alertParentalAccess.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == [alertView cancelButtonIndex]) {
//            
//        }
//        else
//        {
//            NSString *s = [[alertView textFieldAtIndex:0] text];
//            NSInteger answer = [s integerValue];
//            if (a + b != answer)
//            {
//                [UIAlertView showWithTitle:@"Sorry" message:@"It was a wrong answer" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
//                
//            }
//            else
//            {
//                
//            }
//        }
//    };
//    
//    
//    
//    
//    [alertParentalAccess show];
    
    [self performSegueWithIdentifier:@"GotoCardWeb" sender:self];

    
}

- (UIDocumentInteractionController *) setupControllerWithURL:(NSURL *)fileURL
                                               usingDelegate:(id <UIDocumentInteractionControllerDelegate>)         interactionDelegate {
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}





-(UIImage *) screenshot
{
    
    CGRect rect;
    rect=CGRectMake(0, 64, 320, 460);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}









#pragma file processing

- (void) checkFile
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    NSString *updateHistoryFile = [documentsDirectory stringByAppendingPathComponent:@"updateHistory.txt"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:updateHistoryFile]) {
        NSString *string = @"0";
        [fileManager createFileAtPath:updateHistoryFile contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }

    
    
    NSString *favcardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"fav.txt"]];
    
    if (![fileManager fileExistsAtPath:favcardfile]) {
        [fileManager createFileAtPath:favcardfile  contents:nil attributes:nil];
    }

    
    
    
}

+ (Card *)readCardFromFileWithIndex:(int)index
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@".txt"]];

    Card * card = nil;
    

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cardfile]) {
        card = [WebRequest fetchData:[NSString stringWithContentsOfFile:cardfile encoding:NSUTF8StringEncoding error:nil] andIndex:index];
    }
    else
        return nil;
    
    return card;
}


- (void)updateFileWithCard:(Card *)card andDownloadIndex:(int)index
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
    NSString *cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@".txt"]];
    
    
    [fileManager createFileAtPath:cardfile contents:[card.URLresult  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    NSString * str = card.BackgroundImageURL;
    NSURL *url = [[NSURL alloc] initWithString:str];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSString * strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@"_background.png"]];
    NSData * imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:strurl atomically:YES];
    
    str = card.Graphic;
    url = [[NSURL alloc] initWithString:str];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@"_graphic.png"]];
    imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:strurl atomically:YES];
    
    str = card.SizeImageURL;
    url = [[NSURL alloc] initWithString:str];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@"_cardsize.png"]];
    imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:strurl atomically:YES];
    
    
    str = card.FoodHierarchyImageURL;
    url = [[NSURL alloc] initWithString:str];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",index,@"_cardhierarchy.png"]];
    imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:strurl atomically:YES];
    
    
    NSString *updateHistoryFile = [documentsDirectory stringByAppendingPathComponent:@"updateHistory.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:updateHistoryFile]) {
        NSString *string = @"0";
        [fileManager createFileAtPath:updateHistoryFile contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%i", index];
        [string writeToFile:updateHistoryFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}







+ (int) getMaxCardIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *updateHistoryFile = [documentsDirectory stringByAppendingPathComponent:@"updateHistory.txt"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:updateHistoryFile]) {
        return -1;
    }
    
    return [[NSString stringWithContentsOfFile:updateHistoryFile encoding:NSUTF8StringEncoding error:nil] intValue];
    
    
}







#pragma segue action

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CWStatusBarNotification * completedownloadingnotification = [CWStatusBarNotification new];
    completedownloadingnotification.notificationLabelBackgroundColor = [UIColor grayColor];
    completedownloadingnotification.notificationLabelTextColor = [UIColor greenColor];
    completedownloadingnotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    completedownloadingnotification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
    completedownloadingnotification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    
    if ([segue.identifier isEqualToString:@"SearchCards"]) {
        [completedownloadingnotification displayNotificationWithMessage:@"Loading" completion:nil];
        
        
        UINavigationController * nv = segue.destinationViewController;
        SearchTableViewController * searchView = (SearchTableViewController*) nv.topViewController;
        [searchView setDelegate:self];
        
    }
    else if ([segue.identifier isEqualToString:@"ShowDetail"])
    {
        
        
        [completedownloadingnotification displayNotificationWithMessage:@"Loading" completion:nil];
        
        
        UINavigationController * nv = segue.destinationViewController;
        DetailTableViewController * detailView = (DetailTableViewController*) nv.topViewController;
        
        if (isViewFav) {
            [detailView receieveCard:[ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]]];

        }
        else
            [detailView receieveCard:[ViewController readCardFromFileWithIndex:cardindex]];

        [detailView setDelagate:self];
        
    }
    else if ([segue.identifier isEqualToString:@"GotoCardWeb"]) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != NotReachable)
        {
            int index = (isViewFav)? [favCards[favindex] intValue]:cardindex;
            [[segue destinationViewController] recieveCardName:[ViewController readCardFromFileWithIndex:index].Name];

        }
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender isAccessed:(BOOL) isAccess
{
    if ([identifier isEqualToString:@"GotoCardWeb"]) {
        
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connect!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}



- (void)downloadCardsAndSaveToFileWithStartIndex:(int)startIndex
{
    int i = startIndex;
    //NSString * strTest;
    for (int j=0; j<100; ++j) {

        Card * card = [WebRequest fetchData:[NSString stringWithString:[WebRequest stringWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%i",@"http://phylogame.org/?api=json&num=1&page=",i]]]] andIndex:i];
        if (card == nil) {
            return;
        }
        else
        {
//            if (!isViewFav) {
//                [slideCard setMaximumValue:(float)[ViewController getMaxCardIndex]];
//            }
            
            [self updateFileWithCard:card andDownloadIndex:i];
        }
        i ++;        
    }

}



- (IBAction)btnViewFavClick:(id)sender {
    if (btnViewFav.selectedSegmentIndex == 0) {
        //view all clicked
        isViewFav = NO;
        slideCard.maximumValue = [ViewController getMaxCardIndex];
        slideCard.minimumValue = 1;
        [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:cardindex] isTurningRight:YES];
        slideCard.value = cardindex;
        
    }
    else
    {
        if (favCards.count <= 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You don't have any cards saved as favorite yet!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self setToViewAll];
            return;
        }
        
        
        isViewFav = YES;
        slideCard.maximumValue = favCards.count - 1;
        slideCard.minimumValue = 0;
        if ([self isContainCard:[ViewController readCardFromFileWithIndex:cardindex]]) {
            
            int index = (int)[favCards indexOfObject:[NSNumber numberWithInt:cardindex]];
            favindex = index;
            slideCard.value = index;
            [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]] isTurningRight:YES];
        }
        else
        {
            favindex = [self getRandomCardIndex];
            [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]] isTurningRight:YES];
            slideCard.value = favindex;
        }
    }
    
}

- (void) setToViewAll
{
    [btnViewFav setSelectedSegmentIndex:0];
    isViewFav = NO;
    [self removeCardFromFav:[ViewController readCardFromFileWithIndex:cardindex]];
    btnFav.image = [UIImage imageNamed:@"notfav.png"];
    
    slideCard.minimumValue = 1;
    slideCard.maximumValue = [ViewController getMaxCardIndex];
    slideCard.value = cardindex;
}


- (IBAction)btnFavClick:(id)sender {
    if (isViewFav) {
        if ([self isContainCard:[ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]]] ){
            //unfav
            [self removeCardFromFav:[ViewController readCardFromFileWithIndex:[favCards[favindex] intValue]]];
            
            if (favCards.count <= 0) {
                [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:cardindex] isTurningRight:YES];
                [self setToViewAll];
                return;
            }
            
            [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:[[favCards objectAtIndex:[self getRandomCardIndex]] intValue]] isTurningRight:YES];
            
            
        }
    }
    else
    {
        //viewing all
        
        if (![self isContainCard:[ViewController readCardFromFileWithIndex:cardindex]]) {
            //fav
            [self addCardToFav:[ViewController readCardFromFileWithIndex:cardindex]];
            btnFav.image = [UIImage imageNamed:@"fav.png"];
            
        }
        else
        {
            //unfav
            [self removeCardFromFav:[ViewController readCardFromFileWithIndex:cardindex]];
            btnFav.image = [UIImage imageNamed:@"notfav.png"];
        }
    }
    
    
}



- (void) transitionToNewImage: (UIImageView*) imageView
                  andnewimage: (UIImage *) newimage
{

    [imageView setImage:newimage];
    
}

- (void) transitionToNewString: (UILabel *) labelView
                  andnewstring: (NSString *) newString
{

    
    labelView.text = newString;
}







- (void) animation: (NSString *) cardfile
           andCard: (Card *)card
{
    NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithData:[card.CardContent dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    
//    lblCardContent.lineBreakMode = NSLineBreakByWordWrapping;
//    lblCardContent.numberOfLines = 0;
    lblCardContent.attributedText = stringWithHTMLAttributes;
    [lblCardContent setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    
    
    
    stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithData:[card.LatinName dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [self transitionToNewString:lblCardLatinName andnewstring:card.LatinName ];
    lblCardLatinName.lineBreakMode = NSLineBreakByWordWrapping;
    lblCardLatinName.numberOfLines = 0;
    lblCardLatinName.attributedText = stringWithHTMLAttributes;
    [lblCardLatinName setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    [lblCardLatinName setAdjustsFontSizeToFitWidth:YES];
    
    
    
    stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithData:[card.Name dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    lblCardName.attributedText = stringWithHTMLAttributes;
    [lblCardName setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 17.0]];
    [lblCardName setAdjustsFontSizeToFitWidth:YES];
    
    
    [self transitionToNewString:lblCardTemperature andnewstring:card.Temperature];

    
    
    
    
    
    NSString * strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_graphic.png"];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
    [self transitionToNewImage:picCardGraphic andnewimage:image];
    
    
    strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardsize.png"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
    [self transitionToNewImage:picCardSize andnewimage:image];
    
    
    strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardhierarchy.png"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
    [picCardHierarchy setImage:image];
    [self transitionToNewImage:picCardHierarchy andnewimage:image];
    

    strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_background.png"];
    image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
    [picCardBackground setImage:image];
    [self transitionToNewImage:picCardBackground andnewimage:image];
    
    
    
    

}






-(void)putCardOnViewFromFileWithCard: (Card *)card
                      isTurningRight: (BOOL) turnRight
{
    
    int index = card.CardIndex;
    //NSLog(@"%@",card.CardContent);
    if (isViewFav) {
        if ([self isContainCard:card]) {
            favindex = (int)[favCards indexOfObject:[NSNumber numberWithInt:index]];
            slideCard.value = favindex;
        }
        else
        {
            [self setToViewAll];
        }
        
    }
    else
    {
        cardindex = index;
        slideCard.value = cardindex;
    }
    
    
    if ([self isContainCard:card]) {
        btnFav.image = [UIImage imageNamed:@"fav.png"];
    }
    else
    {
        btnFav.image = [UIImage imageNamed:@"notfav.png"];
    }
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSString *cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i",index]];
    
    if (turnRight) {
        [UIView transitionWithView:viewCard duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight| UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
            
            
            [self animation:cardfile andCard:card];
        }completion:nil];
    }
    else
    {
        [UIView transitionWithView:viewCard duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self animation:cardfile andCard:card];
        }completion:nil];
    }
    
    NSURL * soundEffectURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cardFlipSoundEffect" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundEffectURL, &(cardFlipSoundEffectID));
    AudioServicesPlaySystemSound(cardFlipSoundEffectID);

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCardToLeft)];
    swipeLeft.numberOfTouchesRequired = 1;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCardToRight)];
    swipeRight.numberOfTouchesRequired = 1;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeLeft];
    
    
    
    viewCard.layer.cornerRadius = 6;
    viewCard.layer.masksToBounds = YES;
    
    [self checkFile];
    [self checkForFirstCard];
    
    [self readFavCardArrayFromFile];
    
    
    slideCard.minimumValue = 0;
    slideCard.value = 1;
    slideCard.maximumValue = [ViewController getMaxCardIndex];

    

    cardindex = [self getRandomCardIndex];
    
    [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:cardindex] isTurningRight:YES];

    
    
//    [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:cardindex]];
    
    
}

- (void) checkForFirstCard
{
    if ([ViewController getMaxCardIndex]==0) {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != NotReachable)
        {
            NSString * strTest = [[NSString alloc]initWithString:[WebRequest stringWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%i",@"http://phylogame.org/?api=json&num=1&page=",1]]]];
            Card * card = [WebRequest fetchData:strTest andIndex:1];
            if (card == nil) {
                return;
            }
            else
            {
                [self updateFileWithCard:card andDownloadIndex:1];
            }
        }
        else
        {
            UIAlertView * alterview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"For the first launch, please connect to the internet and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alterview show];
        }
        
    }

}

- (int)getRandomCardIndex
{
    int max;
    if (isViewFav) {
        
        max = ((int) favCards.count) -1;
        
    }
    else
    {
        max = [ViewController getMaxCardIndex];
    }
    if (max == 0) {
        return 0;
    }
    else if (!isViewFav && max == 1) {
        return 1;
    }
    
    
    if (isViewFav) {
        int randomindex = arc4random() % (max + 1);
        return randomindex;
    }
    else
    {
        
        int randomindex = arc4random() % (max) + 1;
        return randomindex;
    }
    
}


- (void) timerUpdateCardTick
{
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
    
        //while (true) {
        
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
//    CWStatusBarNotification * completedownloadingnotification = [CWStatusBarNotification new];
//    completedownloadingnotification.notificationLabelBackgroundColor = [UIColor grayColor];
//    completedownloadingnotification.notificationLabelTextColor = [UIColor greenColor];
//    completedownloadingnotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
//    completedownloadingnotification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
//    completedownloadingnotification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    
        
            if (networkStatus != NotReachable)
            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [completedownloadingnotification displayNotificationWithMessage:@"Updating new card" forDuration:2.0];
//                    sleep(2);
//                });
                
                [NSThread detachNewThreadSelector:@selector(updateCards) toTarget:self withObject:nil];
                
                
//                    [completedownloadingnotification displayNotificationWithMessage:[NSString stringWithFormat:@"%i cards are up to date", [ViewController getMaxCardIndex]] forDuration:0.5];
                
                
            }
            
            
//            [lblUpdatingInfo setNeedsDisplay];
//            [self.view updateConstraints];
            //sleep(5);
        //}
//    });
    
    
}



-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    int cindex;
    if (!isViewFav) {
        cindex = cardindex;
    }
    else
    {
        cindex = [[favCards objectAtIndex:favindex] intValue];
    }
    
    int newindex = [self getRandomCardIndex];

    
    BOOL isturningright = (newindex > cindex);
    
    if (isViewFav) {
        newindex = [favCards[newindex] intValue];
    }
    
    
    [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:newindex] isTurningRight:isturningright];
}



- (void)viewDidAppear:(BOOL)animated
{
    [self checkFile];
    [self checkForFirstCard];

    if (!isViewFav) {
        slideCard.minimumValue = 1;
        slideCard.value = cardindex;
        slideCard.maximumValue = [ViewController getMaxCardIndex];
    }
    else
    {
        slideCard.minimumValue = 0;
        slideCard.value = favindex;
        slideCard.maximumValue = favCards.count -1;
    }
    
    

    if (favindex < 0) {
        [self setToViewAll];
    }
    
    if (cardindexchanged) {
        if (isViewFav) {
            
            
            [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex: [favCards[favindex] intValue]] isTurningRight:YES];
            cardindexchanged = NO;
        }
        else
        {
            [self putCardOnViewFromFileWithCard:[ViewController readCardFromFileWithIndex:cardindex] isTurningRight:YES];
            cardindexchanged = NO;
        }
        
    }
    
    [self timerUpdateCardTick];
    
}

- (void) updateCards
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString *updateHistoryFile = [documentsDirectory stringByAppendingPathComponent:@"updateHistory.txt"];
    
    int index = [[NSString stringWithContentsOfFile:updateHistoryFile encoding:NSUTF8StringEncoding error:nil] intValue] + 1;
//   [self downloadCardsAndSaveToFileWithStartIndex:index];
    
    
    
    
    int i = index;
    
    
    
    
    while (true) {
        

        
        @autoreleasepool {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            Card * card;
            NSString *cardfile;
            NSString * str;
            NSString * strurl;
            NSURL *url;
            UIImage *image;
            NSData * imageData;
            NSString *string;
            
            
            card = [WebRequest fetchData:[NSString stringWithString:[WebRequest stringWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%i",@"http://phylogame.org/?api=json&num=1&page=",i]]]] andIndex:i];
            if (card == nil) {
                break;
            }
            else
            {
                
                
                
                
                
                
                cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",i,@".txt"]];
                
                
                [fileManager createFileAtPath:cardfile contents:[card.URLresult  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                
                str = card.BackgroundImageURL;
                url = [[NSURL alloc] initWithString:str];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",i,@"_background.png"]];
                imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:strurl atomically:YES];
                
                str = card.Graphic;
                url = [[NSURL alloc] initWithString:str];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",i,@"_graphic.png"]];
                imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:strurl atomically:YES];
                
                str = card.SizeImageURL;
                url = [[NSURL alloc] initWithString:str];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",i,@"_cardsize.png"]];
                imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:strurl atomically:YES];
                
                
                str = card.FoodHierarchyImageURL;
                url = [[NSURL alloc] initWithString:str];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                strurl = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i%@",i,@"_cardhierarchy.png"]];
                imageData = UIImagePNGRepresentation(image);
                [imageData writeToFile:strurl atomically:YES];
                
                
                
                //            if (![[NSFileManager defaultManager] fileExistsAtPath:updateHistoryFile]) {
                //                NSString *string = @"0";
                //                [fileManager createFileAtPath:updateHistoryFile contents:[string  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                //            }
                //            else
                //            {
                string = [NSString stringWithFormat:@"%i", i];
                [string writeToFile:updateHistoryFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
                //            }
                
                if (!isViewFav) {
                    slideCard.maximumValue = [ViewController getMaxCardIndex];
                    [slideCard setNeedsDisplay];
                }

        }
        
        
            
        }
        i ++;        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end














