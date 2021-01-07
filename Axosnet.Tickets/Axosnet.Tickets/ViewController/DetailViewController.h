//
//  DetailViewController.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 06/01/21.
//


#import <UIKit/UIKit.h>
#import "ReceiptRespository.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+Alert.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate>
@property (strong,nonatomic)  Receipt *receiptDetailObject;
@property BOOL isNew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *providerTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *currencyTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


@end
