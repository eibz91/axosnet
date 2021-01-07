//
//  ReceiptCell.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 05/01/21.
//

#import "ReceiptCell.h"

Receipt *receipt;
@implementation ReceiptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)prepareForReuse{
    [super prepareForReuse];
    
}

- (void)setData:(Receipt *)receipt{
    self.titleLabel.text = receipt.provider;
}

@end
