//
//  ViewController.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 02/01/21.
//

#import <UIKit/UIKit.h>
#import "ReceiptRespository.h"
#import "ReceiptCell.h"
#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (weak,nonatomic) IBOutlet UITableView *myTableView;
   
@end

