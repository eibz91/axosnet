//
//  ReceiptCell.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 05/01/21.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface ReceiptCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)setData:(Receipt *) receipt;

@end

