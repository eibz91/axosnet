//
//  ReceiptRespository.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 03/01/21.
//
#import "ReceiptRespository.h"
#import "NetworkManager.h"


@interface ReceiptRespository()

@end

@implementation ReceiptRespository




- (void)List:(ReceiptList)success{

    
    [[NetworkManager sharedManager] GetMethod:@"getall" needAuth:false success:^(id responseObject,NSInteger statusCode) {
        NSError *error;
        NSArray <Receipt *> *post2 = [Receipt arrayOfModelsFromData:responseObject error:&error];
        
        success(post2,NO_ERROR);
    } failer:^(NSString *failureReason, NSInteger statusCode) {
        success(nil,ERROR);
    }];
}
- (void)Detail:(ReceiptDetail)success id:(NSNumber *)receiptId{
    [[NetworkManager sharedManager] GetMethod:[NSString stringWithFormat:@"getbyid?id=%@", receiptId] needAuth:false success:^(id responseObject,NSInteger statusCode) {
        NSError *error;
        NSArray <Receipt *> *receiptList = [Receipt arrayOfModelsFromData:responseObject error:&error];
        if ([receiptList count] != 0 ){
            success([receiptList firstObject],NO_ERROR);
        }else{
            success(nil,NO_ERROR);
        }
       
       
    } failer:^(NSString *failureReason, NSInteger statusCode) {
        success(nil,ERROR);
    }];
}

- (void)Create:(ReceiptDetail)success id:(NSString *)parameters{
    [[NetworkManager sharedManager] PostMethod:[NSString stringWithFormat:@"insert?%@",parameters] needAuth:false success:^(id responseObject,NSInteger statusCode) {
        if (statusCode != 200 ){
            success(nil,NO_ERROR);
        }else{
            success(nil,NO_ERROR);
        }
    } failer:^(NSString *failureReason, NSInteger statusCode) {
        success(nil,ERROR);
    }];
}

- (void)Update:(ReceiptDetail)success id:(NSString *)parameters{
    [[NetworkManager sharedManager] PostMethod:[NSString stringWithFormat:@"update?%@",parameters] needAuth:false success:^(id responseObject,NSInteger statusCode) {
        if (statusCode != 200 ){
            success(nil,NO_ERROR);
        }else{
            success(nil,NO_ERROR);
        }
    } failer:^(NSString *failureReason, NSInteger statusCode) {
        success(nil,ERROR);
    }];
}

- (void)Delete:(ReceiptDetail)success id:(NSInteger )receiptId{
    [[NetworkManager sharedManager] PostMethod:[NSString stringWithFormat:@"delete?id=%ld", receiptId] needAuth:false success:^(id responseObject,NSInteger statusCode) {
        if (statusCode != 200 ){
            success(nil,NO_ERROR);
        }else{
            success(nil,NO_ERROR);
        }
    } failer:^(NSString *failureReason, NSInteger statusCode) {
        success(nil,ERROR);
    }];
}

@end
