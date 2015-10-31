//
//  WebPageViewController.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-16.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController
{
    IBOutlet UIWebView *webView;
    
    IBOutlet UINavigationItem *webTitle;
    
}


- (void) recieveCardName: (NSString *) cardname;
- (void) gotoPhyloGameOrg;

@end
