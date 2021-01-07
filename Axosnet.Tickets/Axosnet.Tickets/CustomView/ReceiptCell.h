//
//  ReceiptCell.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 05/01/21.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface ReceiptCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)setData:(Receipt *) receipt;

@end

