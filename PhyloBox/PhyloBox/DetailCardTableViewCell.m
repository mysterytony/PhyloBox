//
//  DetailCardTableViewCell.m
//  PhyloBox
//
//  Created by MysteryTony on 2014-05-13.
//  Copyright (c) 2014 Tony Li. All rights reserved.
//

#import "DetailCardTableViewCell.h"

@implementation DetailCardTableViewCell
@synthesize picFoodHierarchy, picCardSize,picCardImage, lblTerrian, lblTemperature, lblLatinName, lblCardName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        picCardImage = [[UIImageView alloc] init];
        picCardSize = [[UIImageView alloc] init];
        picFoodHierarchy = [[UIImageView alloc] init];
        
        lblCardName = [[UILabel alloc] init];
        lblLatinName = [[UILabel alloc] init];
        lblTerrian = [[UILabel alloc] init];
        lblTemperature = [[UILabel alloc] init];
        
        
        [picCardImage setFrame:CGRectMake(0, 0, 160, 99)];
        [picCardSize setFrame:CGRectMake(104, 0, 28, 28)];
        [picFoodHierarchy setFrame:CGRectMake(132, 0, 28, 28)];
        
        [lblCardName setFrame:CGRectMake(168, 0, 152, 21)];
        [lblLatinName setFrame:CGRectMake(168, 20, 152, 32)];
        [lblTerrian setFrame:CGRectMake(168, 62, 152, 17)];
        [lblTemperature setFrame:CGRectMake(168, 82, 152, 17)];
        
        
        [lblCardName setAdjustsFontSizeToFitWidth:YES];
        
        
        
        [lblLatinName setAdjustsFontSizeToFitWidth:YES];
        [lblLatinName setTextColor:[UIColor darkGrayColor]];
        
        [lblTerrian setFont:[UIFont systemFontOfSize:14]];
        [lblTerrian setTextAlignment:NSTextAlignmentRight];
        [lblTerrian setTextColor:[UIColor lightGrayColor]];
        [lblTerrian setAdjustsFontSizeToFitWidth:YES];
        
        [lblTemperature setFont:[UIFont systemFontOfSize:14]];
        [lblTemperature setTextAlignment:NSTextAlignmentRight];
        [lblTemperature setTextColor:[UIColor lightGrayColor]];
        [lblTemperature setAdjustsFontSizeToFitWidth:YES];
        
        
        [self addSubview: picCardImage];
        [self addSubview: picCardSize];
        [self addSubview: picFoodHierarchy];
        
        [self addSubview: lblCardName];
        [self addSubview: lblLatinName];
        [self addSubview: lblTerrian];
        [self addSubview: lblTemperature];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
