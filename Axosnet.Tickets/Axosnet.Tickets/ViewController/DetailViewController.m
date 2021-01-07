//
//  DetailViewController.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 02/01/21.
//

#import "DetailViewController.h"


@interface DetailViewController ()


@end

ReceiptRespository *detailReceipRepository;
NSMutableDictionary *parameters;
@implementation DetailViewController
UIDatePicker *dpDatePicker;
NSString *formatedDate;
NSString * segueUnwind = @"unwindToHomeFromDetail";
NSString * segueBack = @"unwindToHomeBack";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    
}
-(void)initData{

    self.isNew = self.receiptDetailObject.id==nil;
    
    dpDatePicker = [[UIDatePicker alloc] init];
    dpDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [dpDatePicker setMinimumDate: [NSDate date]];

    dpDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePicker.timeZone = [NSTimeZone defaultTimeZone];
    dpDatePicker.minuteInterval = 5;
    
    [_dateTextField setInputView:dpDatePicker];
    self.dateTextField.delegate = self;

    detailReceipRepository = [[ReceiptRespository alloc] init];
    self.titleLabel.text = NSLocalizedString(self.receiptDetailObject == nil ? @"detai_view_title_new" : @"detai_view_title_edit", "title for detail view") ;
    if (self.receiptDetailObject != nil) {
        [self fetchData];
    }else{
        self.receiptDetailObject = [[Receipt alloc] init];
        [self setDateTextFieldData];
    }
}

-(void)setDataFromRequest{
    self.providerTextField.text = self.receiptDetailObject.provider;
    self.amountTextField.text = [NSString stringWithFormat:@"%.2f", self.receiptDetailObject.amount];
    self.dateTextField.text = self.receiptDetailObject.emissionDate;
    self.currencyTextField.text = self.receiptDetailObject.currencyCode;
    self.commentTextView.text = self.receiptDetailObject.comment;
    NSString *dateString =  self.receiptDetailObject.emissionDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateString = [dateString substringToIndex:(dateString.length - 2)];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.receiptDetailObject.emissionDate = [dateFormatter stringFromDate:date];
}

-(void) fetchData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [detailReceipRepository Detail:^(Receipt * _Nullable detial, ResponseError statusCode) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (detial != nil) {
                self.receiptDetailObject = detial;
                [self setDataFromRequest];
                
            }else{
                [self showAlert:NSLocalizedString(@"detai_view_detail_fetch", "Error when cant get detail from receipt")];
                
            }
        } id:self.receiptDetailObject.id];
    });
}

- (BOOL)validateData{
    BOOL isValid = YES;
    if ([self.providerTextField.text length] <= 0){
        isValid = NO;
    }
    if ([self.amountTextField.text length] <= 0){
        isValid = NO;
    }
    if ([self.currencyTextField.text length] <= 0){
        isValid = NO;
    }
    return YES;
}


- (IBAction)saveAction:(id)sender {
    
    if ([self validateData]){
        /// send data to update
        NSString *url = [self prepareUrlData:self.isNew];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.isNew){
            [detailReceipRepository Create:^(Receipt * _Nullable detial, ResponseError statusCode) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (statusCode == NO_ERROR){
                    [self performSegueWithIdentifier:segueUnwind sender:nil];
                }else{
                [self showAlert:NSLocalizedString(@"detai_view_detail_create", "Error when trying to update this receipt")];
                }
                
            } id:url];
        }else{
            [detailReceipRepository Update:^(Receipt * _Nullable detial, ResponseError statusCode) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (statusCode == NO_ERROR){
                    [self performSegueWithIdentifier:segueUnwind sender:nil];
                }else{
                    [self showAlert:NSLocalizedString(@"detai_view_detail_update", "Error when trying to update this receipt")];
                }
            } id:url];
        }
        
    }else{
        [self showAlert:NSLocalizedString(@"detai_view_detail_validation", "validation error message")];
    }
}

- (IBAction)backAction:(id)sender {
    [self performSegueWithIdentifier:segueBack sender:nil];
}


- (void)datePickerValueChanged:(id)sender {
    [self setDateTextFieldData];
}

- (void)setDateTextFieldData{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/y hh:mm:ss a"];
    self.dateTextField.text = [dateFormatter stringFromDate:dpDatePicker.date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.receiptDetailObject.emissionDate = [dateFormatter stringFromDate:dpDatePicker.date];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return  NO;
}


- (NSString *)prepareUrlData:(BOOL)isNew{
    parameters = [[NSMutableDictionary alloc] init];
    self.receiptDetailObject.comment = self.commentTextView.text;
    self.receiptDetailObject.amount =  [self.amountTextField.text floatValue];
    self.receiptDetailObject.provider = self.providerTextField.text;
    self.receiptDetailObject.currencyCode = self.currencyTextField.text;
   
    if (!isNew)
        [parameters setObject:self.receiptDetailObject.id forKey:@"id"];
    [parameters setObject:self.receiptDetailObject.emissionDate forKey:@"emission_date"];
    [parameters setObject:self.receiptDetailObject.comment forKey:@"comment"];
    [parameters setObject:self.receiptDetailObject.currencyCode forKey:@"currency_code"];
    [parameters setObject:self.receiptDetailObject.provider forKey:@"provider"];
    [parameters setObject:[NSNumber numberWithFloat:self.receiptDetailObject.amount]  forKey:@"amount"];
    
    NSMutableString *resultString = [NSMutableString string];
    for (NSString* key in [parameters allKeys]){
        if ([resultString length]>0){
            [resultString appendString:@"&"];
        }
        [resultString appendFormat:@"%@=%@", key, [parameters objectForKey:key]];
    }
    NSString *url = [resultString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return  url;
}

@end

