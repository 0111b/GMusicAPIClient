//
//  GMusicBaseClient.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMAPIClient+Protected.h"

@interface GMAPIClient ()

@end

@implementation GMAPIClient

+ (instancetype) sharedInstance {
    static id shared = nil;    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype) initUniqueInstance {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setName:@"com.gmusicapi.processing"];
        self.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        
        self.tokens = [GMSessionTokens new];
    }
    return self;
}

- (void)dealloc {
    [self logout];
    [self.session invalidateAndCancel];
}

- (void)executeCompletion:(GMCompletionBlock)completion withResult:(GMResult *)result {
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }
}

- (void)executeCallWithoutAuth:(GMCall *)call withCompletion:(GMCompletionBlock)completion {
    [self executeCall:call withCompletion:completion needAuth:NO];
}

- (void)executeCall:(GMCall *)call withCompletion:(GMCompletionBlock)completion {
    [self executeCall:call withCompletion:completion needAuth:YES];
}

- (void)executeCall:(GMCall *)call withCompletion:(GMCompletionBlock)completion needAuth:(BOOL)needAuth {
    //TODO: add error checking
    if (needAuth && ![self isAuthenticated]) {
        [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusInvalidCredentials]];
        return;
    }
    
    NSMutableURLRequest *request = call.request;
    //TODO: send response
    void (^requestCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        GMResult *result = nil;
        if (error) {
            result = [GMResult resultWithStatus:GMStatusNetworkError error:error];
        } else {
            result = [call processData:data withResponse:response];
        }
        if (result) {
            [self executeCompletion:completion withResult:result];
        }
    };    
    [[self.session dataTaskWithRequest:request completionHandler:requestCompletion] resume];
}

#pragma mark -
- (void)loginWithCredentials:(GMCredentials *)crendetials completion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (void)allSongsWithCompletion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (void)streamURLForTrackId:(NSString *)trackId completion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (BOOL)isAuthenticated {
    return NO;
}
- (void)logout {
    self.credentials = nil;
    self.tokens = nil;    
}
@end
