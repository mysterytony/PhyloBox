//
//  InfoViewController.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-11.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "InfoViewController.h"
#import "WebPageViewController.h"
#import "Reachability.h"
#import "UIAlertView+Blocks.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [scrollView setContentSize:CGSizeMake(960, 504)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GotoPhyloPage"])
    {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus != NotReachable)
        {
            [[segue destinationViewController] gotoPhyloGameOrg];
            
        }
    }
}

- (IBAction)btnDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnGotoPhyloWebpageClicked:(id)sender {
    
    
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
    
    [self performSegueWithIdentifier:@"GotoPhyloPage" sender:self];
    
}
@end
