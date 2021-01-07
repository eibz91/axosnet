//
//  Receipt.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 05/01/21.
//
#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface Receipt : JSONModel
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *provider;
@property (nonatomic) float amount;
@property (nonatomic) NSString *emissionDate;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSString *currencyCode;
@end
