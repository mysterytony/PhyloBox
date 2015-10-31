//
//  DetailTableViewController.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-13.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "DetailTableViewController.h"
#import "ViewController.h"
#import "Card.h"
#import "DetailCardTableViewCell.h"
#import "WebPageViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

@synthesize delagate;//,cards,results;
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) addElementWithArray: (NSMutableArray*) arr
                      andobj: (id) obj
{
    if (![arr containsObject:obj]) {
        [arr addObject:obj];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
[self.searchDisplayController.searchResultsTableView registerClass:[DetailCardTableViewCell class] forCellReuseIdentifier:@"SearchCell"];
    
    int max = [ViewController getMaxCardIndex];
    Card * tempcard = [[Card alloc] init];
    for (int i= 1; i<=max; ++i) {
        tempcard = [ViewController readCardFromFileWithIndex:i];
        if ([self isCompatible:tempcard]) {
            [self addElementWithArray:self.cards andobj:tempcard];
        }
    }
    
}



- (BOOL) isCompatible: (Card *) othercard
{
    BOOL istempcom = NO;
    // "cold,cool,hot"
    NSMutableArray * temp1 = [NSMutableArray arrayWithArray: [othercard.Temperature componentsSeparatedByString:@","]];
    
    
    for (int i=0;i<temp1.count;++i) {
        temp1[i] = [temp1[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([card.Temperature rangeOfString:temp1[i]].location != NSNotFound) {
            istempcom = YES;
            break;
        }
    }
    
    BOOL isHabcom = NO;
    if ([card.Habitat1 isEqualToString:othercard.Habitat1] ||
        [card.Habitat1 isEqualToString:othercard.Habitat2] ||
        [card.Habitat1 isEqualToString:othercard.Habitat3] ||
        [card.Habitat2 isEqualToString:othercard.Habitat1] ||
        [card.Habitat2 isEqualToString:othercard.Habitat2] ||
        [card.Habitat2 isEqualToString:othercard.Habitat3] ||
        [card.Habitat3 isEqualToString:othercard.Habitat1] ||
        [card.Habitat3 isEqualToString:othercard.Habitat2] ||
        [card.Habitat3 isEqualToString:othercard.Habitat3]
        ) {
        isHabcom = YES;
    }
    
    if (istempcom && isHabcom) {
        return YES;
    }
    return NO;
    
}


- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)receieveCard:(Card *)newcard
{
    card = newcard;
    self.navigationItem.title = card.Name;
    
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
    
    // Configure the cell...
    
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
        
        
        Card * cardt = self.results[indexPath.row];
        //            NSArray * viewControllers = [self.navigationController viewControllers];
        
        //        [[segue destinationViewController] setCardIndexTo:card.CardIndex];
        //            [self.navigationController popViewControllerAnimated:YES];

        [[self delagate] setCardIndexTo:cardt.CardIndex];
    }
    else
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.cards.count < indexPath.row || indexPath == nil) {
            return;
        }
        
        Card * cardt = self.cards[indexPath.row];
        //        [[segue destinationViewController] setCardIndexTo:card.CardIndex];
        
        //            [self.navigationController popViewControllerAnimated:YES];
        [[self delagate] setCardIndexTo:cardt.CardIndex];
    }
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchThroughCards];
}

- (void) searchThroughCards
{
    self.results = [[NSMutableArray alloc] init];
    NSString * searchText = self.searchBar.text;
    for (Card * cardt in self.cards) {
        if ([cardt.URLresult rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self addElementWithArray:self.results andobj:cardt];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
