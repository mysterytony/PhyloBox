//
//  WebPageViewController.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-16.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()

@end

@implementation WebPageViewController

NSURL * weburl;

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
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    NSURLRequest * request = [NSURLRequest requestWithURL:weburl];
    [webView loadRequest:request];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gotoPhyloGameOrg
{
    webTitle.title = @"PhyloGame.org";
    NSURL * url = [NSURL URLWithString:@"http://phylogame.org"];
    weburl = url;

}

- (void) recieveCardName: (NSString *) cardname
{
    webTitle.title = cardname;
    cardname = [cardname stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL * url = [NSURL URLWithString:@"http://en.wikipedia.org/wiki"];
    url = [url URLByAppendingPathComponent:cardname];
    weburl = url;
    
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
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

@end
