//
//  ListCell.m
//  TableViewListDemo
//
//  Created by Liwp on 17/1/24.
//  Copyright © 2017年 Liwp. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pokeLabel.text = @"皮卡，皮卡";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
