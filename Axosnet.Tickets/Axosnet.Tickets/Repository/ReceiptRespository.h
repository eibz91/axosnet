//
//  ReceiptRespository.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 03/01/21.
//
#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Receipt.h"

typedef void (^ReceiptList)(NSArray <Receipt *> * _Nullable list, ResponseError statusCode);
typedef void (^ReceiptDetail)(Receipt * _Nullable detial, ResponseError statusCode);
@interface ReceiptRespository : NSObject
- (void)List:(ReceiptList _Nullable )success;
- (void)Detail:(ReceiptDetail _Nullable )success id:(NSNumber *_Nonnull) receiptId;
- (void)Create:(ReceiptDetail _Nullable )success id:(NSString *_Nonnull) parameters;
- (void)Update:(ReceiptDetail _Nullable )success id:(NSString *_Nonnull) parameters;
- (void)Delete:(ReceiptDetail _Nullable )success id:(NSInteger ) receiptId;

@end
