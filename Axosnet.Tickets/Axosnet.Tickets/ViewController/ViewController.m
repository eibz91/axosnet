//
//  ViewController.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 02/01/21.
//

#import "ViewController.h"


@interface ViewController ()


@end
NSString * _Nonnull cellReuseIdentifier = @"ReceiptCell";
NSString * segue = @"fromHomeToDetail";

NSMutableArray *receiptArray;
NSArray *datad;
ReceiptRespository *receipRepositoryd;
UIRefreshControl *refreshController;
NSInteger selectedIndex;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
   
   
}
-(void)initTable{

    receiptArray = [[NSMutableArray alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshController];
    receipRepositoryd = [[ReceiptRespository alloc] init];
    [self fetchData];
    
}

-(void) fetchData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [receipRepositoryd List:^(NSArray<Receipt *> * _Nullable list, ResponseError statusCode) {
            if (list != nil) {
                [receiptArray addObjectsFromArray:list];
                [self.myTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:NSLocalizedString(@"main_view_list", comment: "when a user try to delete a row")];
            }
        }];
    });
}


// number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return receiptArray.count;
}

// create a cell for each table view row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ReceiptCell";
    NSInteger row = indexPath.row ?: 0;
    ReceiptCell *cell = (ReceiptCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiptCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setData:receiptArray[row]];
    return cell;
}

// method to run when table view cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row ?: 0;
    selectedIndex = row;
    [self performSegueWithIdentifier:segue sender:receiptArray[selectedIndex]];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row ?: 0;
        Receipt *selectedReceipt = receiptArray[selectedIndex];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [receipRepositoryd Delete:^(Receipt * _Nullable detial, ResponseError statusCode) {
                if (statusCode == NO_ERROR) {
                    [receiptArray removeObjectAtIndex:row];
                    [tableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showAlert:NSLocalizedString(@"main_view_delete_row", comment: "when a user try to delete a row")];
                }
            }id:[selectedReceipt.id intValue]];
        });
    }
}

-(void)handleRefresh : (id)sender
{
    [receiptArray removeAllObjects];
    [self.myTableView reloadData];
    [self fetchData];
    [refreshController endRefreshing];
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
    DetailViewController *controller = (DetailViewController *)unwindSegue.sourceViewController;
    if (controller.isNew){
        /// IN CASE THAT RESPONSE HAS OBJECT CREATED
//        [receiptArray addObject:controller.receiptDetailObject];
//        [self.myTableView reloadData];
        /// IN CASE THAT RESPONSE HAS EMPTY BODY
        [self handleRefresh:nil];
        
    }else{
        receiptArray[selectedIndex] = controller.receiptDetailObject;

        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [self.myTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (IBAction)addReceipt:(id)sender {
    [self performSegueWithIdentifier:segue sender:nil];
}

- (IBAction)unwindToHomeBack:(UIStoryboardSegue *)unwindSegue {

}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"fromHomeToDetail"]){
        Receipt *receipt ;
        if (sender != nil){
            receipt = (Receipt *)sender;
        }
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        controller.receiptDetailObject = receipt;
    }
}


@end
