//
//  NetworkManager.m
//  Axosnet.Tickets
//
//  Created by eibz91 on 03/01/21.
//

#import "NetworkManager.h"

@interface NetworkManager()

@end

@implementation NetworkManager


static NetworkManager *sharedManager = nil;

+(NetworkManager*)sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[NetworkManager alloc] init];
    });
    
    return sharedManager;
}

-(id)init{
    if ((self = [super init])) {
        NSString* url = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiUrl"];
        self.baseUrl = url;
    }
    return self;
    
}




- (AFHTTPSessionManager*)getNetworkingManager {
    if (self.networkingManager == nil) {
        self.networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.networkingManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.networkingManager.requestSerializer setTimeoutInterval:1];
        self.networkingManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.networkingManager.securityPolicy = [self getSecurityPolicy];
    }
    return self.networkingManager;
}

- (id)getSecurityPolicy {
    return [AFSecurityPolicy defaultPolicy];

}

- (NSString*)getError:(NSError*)error {
    if (error != nil) {
        return [error localizedDescription];
    }
    return @"Server Error. Please try again later";
}



- (void)authenticateWithEmail:(NSString*)email password:(NSString*)password success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure {
    if (email != nil && [email length] > 0 && password != nil && [password length] > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:email forKey:@"email"];
        [params setObject:password forKey:@"password"];
        [[self getNetworkingManager] POST:@"/post" parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success != nil) {
                success(responseObject,((NSHTTPURLResponse*)task.response).statusCode);
            }
        } failure:^(NSURLSessionDataTask *operation, NSError * _Nonnull error) {
            NSString *errorMessage = [self getError:error];
            if (failure != nil) {
                failure(errorMessage, ((NSHTTPURLResponse*)operation.response).statusCode);
            }
        }];
    } else {
        if (failure != nil) {
            failure(@"Email and Password Required", -1);
        }
    }
}


-(void)GetMethod:(NSString*)url
          needAuth:(BOOL) auth
         success:(NetworkManagerSuccess)success
          failer:(NetworkManagerFailure)failure{

    [[self getNetworkingManager] GET:[NSString stringWithFormat:@"%@%@",self.baseUrl,url] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success([self HandleResponse:responseObject],((NSHTTPURLResponse*)task.response).statusCode);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError * _Nonnull error) {
        NSString *errorMessage = [self getError:error];
        if (failure != nil) {
            failure(errorMessage, ((NSHTTPURLResponse*)operation.response).statusCode);
        }
    }];
}

-(void)PostMethod:(NSString*)url
          needAuth:(BOOL) auth
         success:(NetworkManagerSuccess)success
          failer:(NetworkManagerFailure)failure{

    [[self getNetworkingManager] POST:[NSString stringWithFormat:@"%@%@",self.baseUrl,url] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success != nil) {
            success([self HandleResponse:responseObject],((NSHTTPURLResponse*)task.response).statusCode);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError * _Nonnull error) {
        NSString *errorMessage = [self getError:error];
        if (failure != nil) {
            failure(errorMessage, ((NSHTTPURLResponse*)operation.response).statusCode);
        }
    }];
}


-(NSData *)HandleResponse:(NSData *)response{
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//    NSString *responseString = @"\"[{\\\"id\\\":228,\\\"provider\\\":\\\"axosnet2\\\",\\\"amount\\\":120.32,\\\"emission_date\\\":\\\"1/1/2019 12:00:00 AM\\\",\\\"comment\\\":\\\"comment2\\\",\\\"currency_code\\\":\\\"MXN\\\"}]\"";
    if ([responseString length] != 0){
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\\""
                                                   withString:@"\""];
        responseString = [responseString substringFromIndex:1];
        responseString = [responseString substringToIndex:[responseString length] - 1];
        return [responseString dataUsingEncoding:NSUTF8StringEncoding];;
    }
    return nil;
    
}

@end
