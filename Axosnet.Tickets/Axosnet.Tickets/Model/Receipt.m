//
//  Receipt.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 05/01/21.
//

#import "Receipt.h"

@interface Receipt()

@end

@implementation Receipt
+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
