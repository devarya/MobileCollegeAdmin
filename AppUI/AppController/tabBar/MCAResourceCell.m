//
//  MCAResourceCell.m
//  MobileCollegeAdmin
//
//  Created by Dongjie Zhang on 9/14/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourceCell.h"

@implementation MCAResourceCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
