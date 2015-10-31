//
//  SearchTableViewController.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-08.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "SearchTableViewController.h"
#import "ViewController.h"
#import "Card.h"
#import "DetailCardTableViewCell.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
@synthesize delegate;
static NSString* cardCellIdentifier = @"CardCell";


- (NSMutableArray *) cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableArray *) results
{
    if (!_results) {
        _results = [[NSMutableArray alloc] init];
    }
    return _results;
}

- (void) addElementWithArray: (NSMutableArray*) arr
                              andobject: (id) obj
{
    if (![arr containsObject:obj]) {
        [arr addObject:obj];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
////    if ([[segue identifier] isEqualToString:@"ShowCard"]) {
////    
////        if (self.searchDisplayController.isActive) {
////            NSIndexPath * indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
////            Card * card = self.results[indexPath.row];
//////            NSArray * viewControllers = [self.navigationController viewControllers];
////            
////            [[segue destinationViewController] setCardIndexTo:card.CardIndex];
//////            [self.navigationController popViewControllerAnimated:YES];
////        }
////        else
////        {
////            NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
////            Card * card = self.cards[indexPath.row];
////            [[segue destinationViewController] setCardIndexTo:card.CardIndex];
////            
//////            [self.navigationController popViewControllerAnimated:YES];
////            
////        }
////        
////    }
//}







- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
    [self.tableView registerClass:[DetailCardTableViewCell class] forCellReuseIdentifier:cardCellIdentifier];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[DetailCardTableViewCell class] forCellReuseIdentifier:@"SearchCell"];
    
    
    //add cards to mutable array
    
//    self.cards = [[NSMutableArray alloc] init];
//    self.results = [[NSMutableArray alloc] init];
    
    int max = [ViewController getMaxCardIndex];
    Card * card = [[Card alloc] init];
    for (int i=1; i<=max; ++i) {
        card = [ViewController readCardFromFileWithIndex:i];
        [self addElementWithArray:self.cards andobject:card];
//        [self.cards addObject:card];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (tableView == self.tableView) {
        return self.cards.count;
    }
    else
    {
        [self searchThroughCards];
        return self.results.count;
    }
}


- (DetailCardTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailCardTableViewCell *cell;
    
    if (!cell) {
        cell = [[DetailCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:cardCellIdentifier];
        Card * cardt = self.cards[indexPath.row];
        //        cell.textLabel.text = cardt.Name;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        
        NSString *cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i",cardt.CardIndex]];
        
        NSAttributedString * stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithData:[cardt.Name dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        cell.lblCardName.attributedText = stringWithHTMLAttributes;
        
        
        cell.lblLatinName.text  = cardt.LatinName;
        cell.lblTemperature.text = cardt.Temperature;
        cell.lblTerrian.text = [NSString stringWithFormat:@"%@ %@ %@", cardt.Habitat1, cardt.Habitat2, cardt.Habitat3];
        
        NSString * strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_graphic.png"];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picCardImage setImage:image];
        
        strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardsize.png"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picCardSize setImage:image];
        
        strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardhierarchy.png"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picFoodHierarchy setImage:image];
        
        [cell setBackgroundColor:[self getUIColorObjectFromHexString:cardt.CardColor alpha:1.0]];
    }
    else
    {
 
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        //        Card * cardt = self.results[indexPath.row];
        Card * cardt = self.results[indexPath.row];
        //        cell.textLabel.text = cardt.Name;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        
        
        NSString *cardfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i",cardt.CardIndex]];
        
        NSAttributedString * stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithData:[cardt.Name dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        cell.lblCardName.attributedText = stringWithHTMLAttributes;
        
        cell.lblLatinName.text  = cardt.LatinName;
        cell.lblTemperature.text = cardt.Temperature;
        cell.lblTerrian.text = [NSString stringWithFormat:@"%@ %@ %@", cardt.Habitat1, cardt.Habitat2, cardt.Habitat3];
        
        NSString * strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_graphic.png"];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picCardImage setImage:image];
        
        strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardsize.png"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picCardSize setImage:image];
        
        strurl = [NSString stringWithFormat:@"%@%@", cardfile, @"_cardhierarchy.png"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:strurl]];
        [cell.picFoodHierarchy setImage:image];
        
        [cell setBackgroundColor:[self getUIColorObjectFromHexString:cardt.CardColor alpha:1.0]];
        NSLog(@"%@+%@", cardt.Name, cardt.CardColor);
        
    }
    
    
    
    
    
    
    return cell;
}


- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.isActive) {
        NSIndexPath * indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
        
        if (self.results.count < indexPath.row || indexPath == nil) {
            return;
        }
        Card * card = self.results[indexPath.row];
        //            NSArray * viewControllers = [self.navigationController viewControllers];
        
//        [[segue destinationViewController] setCardIndexTo:card.CardIndex];
        //            [self.navigationController popViewControllerAnimated:YES];
        [[self delegate] setCardIndexTo:card.CardIndex];
    }
    else
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.cards.count < indexPath.row || indexPath == nil) {
            return;
        }
        Card * card = self.cards[indexPath.row];
//        [[segue destinationViewController] setCardIndexTo:card.CardIndex];
        
        //            [self.navigationController popViewControllerAnimated:YES];
        [[self delegate] setCardIndexTo:card.CardIndex];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchThroughCards];
}


- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchThroughCards
{
    self.results = [[NSMutableArray alloc] init];
    NSString * searchText = self.searchBar.text;
    for (Card * card in self.cards) {
        if ([card.URLresult rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self addElementWithArray:self.results andobject:card];
        }
//        if ([card.Name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.LatinName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.CardContent rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Food rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Habitat1 rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Habitat2 rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Habitat3 rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Hierarchy rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.Temperature rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
//        
//        if ([card.URLresult rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.results addObject:card];
//        }
        
        
        
    }
//    NSPredicate * resultredicate = [NSPredicate predicateWithFormat:@"SELF like %@", self.searchBar.text];
//    self.results = [[self.cards filteredArrayUsingPredicate:resultredicate] mutableCopy];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
