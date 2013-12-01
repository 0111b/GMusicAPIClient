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
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    [self logout];
}

- (void)executeCompletion:(GMCompletionBlock)completion withResult:(GMResult *)result {
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }
}

#pragma mark -
- (void)loginWithCredentials:(GMCredentials *)crendetials completion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (void)allSongsWithCompletion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (void)streamURLForTrack:(GMTrackInfo *)track completion:(GMCompletionBlock)completion {
    [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusConsistencyError error:nil]];
}

- (BOOL)isAuthenticated {
    return NO;
}
- (void)logout {
    
}
@end
