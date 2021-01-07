//
//  NetworkManger.h
//  Axosnet.Tickets
//
//  Created by eibz91 on 03/01/21.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum
{
    NO_ERROR,
    ERROR
} ResponseError;


typedef void (^NetworkManagerSuccess)(id responseObject,NSInteger statusCode);
typedef void (^NetworkManagerFailure)(NSString *failureReason, NSInteger statusCode);
@interface NetworkManager : NSObject

@property NSString *baseUrl;
@property (nonatomic, strong) AFHTTPSessionManager *networkingManager;

+ (id) sharedManager;
- (void)authenticateWithEmail:(NSString*)email password:(NSString*)password success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;
- (void)GetMethod:(NSString*)url needAuth:(BOOL) auth success:(NetworkManagerSuccess)success failer:(NetworkManagerFailure)failure;
- (void)PostMethod:(NSString*)url needAuth:(BOOL) auth success:(NetworkManagerSuccess)success failer:(NetworkManagerFailure)failure;




@end
