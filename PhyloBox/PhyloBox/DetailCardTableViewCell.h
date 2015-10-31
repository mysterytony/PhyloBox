//
//  DetailCardTableViewCell.h
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-13.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCardTableViewCell : UITableViewCell
{

    
}

@property IBOutlet UIImageView *picCardImage;
@property IBOutlet UIImageView *picCardSize;
@property IBOutlet UIImageView *picFoodHierarchy;
@property IBOutlet UILabel *lblCardName;
@property IBOutlet UILabel *lblLatinName;
@property IBOutlet UILabel *lblTerrian;
@property IBOutlet UILabel *lblTemperature;

@end
