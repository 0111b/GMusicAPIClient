//
//  GMWebClient.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMWebClient.h"

#import "GMCallListPlaylists.h"
#import "GMCallStreamURLForTrack.h"
#import "GMCallAllSongs.h"
#import "GMCallWebclientLogin.h"

@interface GMWebClient () <NSURLSessionDelegate>
@end

@implementation GMWebClient
- (instancetype) initUniqueInstance {
    self = [super initUniqueInstance];
    if (self) {        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = NO;
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    }
    return self;
}

#pragma mark -

- (BOOL)isAuthenticated {
    return self.tokens.authToken.length && self.tokens.xtToken.length && self.credentials;
}

#pragma mark -

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    GMLog(@"session is invalid: %@",error);
    //TODO: handle errors    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.credentials.username password:self.credentials.password persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

#pragma mark -

- (void)loginWithCredentials:(GMCredentials *)crendetials
                  completion:(GMCompletionBlock)completion {
    if (!crendetials.username.length || !crendetials.password.length) {
        [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusInvalidArg]];
    }
    
    if ([self isAuthenticated]) {
        [self logout];
        self.tokens = [GMSessionTokens new];
    }
    self.credentials = crendetials;
    __weak typeof(*&self)weakself = self;
    
    GMCompletionBlock xtCompletion = ^(GMResult *result) {
        if (![result isValid]) {
           [weakself executeCompletion:completion withResult:result];
            return ;
        }
        NSHTTPCookieStorage *cookieStorage = weakself.session.configuration.HTTPCookieStorage;
        for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
            if ([[cookie name] isEqualToString:@"xt"]) {
                weakself.tokens.xtToken = [cookie value];
                GMLog(@"xtToken %@",weakself.tokens.xtToken);
                break;
            }
        }
        GMResult *finalResult = [weakself isAuthenticated]?[GMResult resultDone]:[GMResult resultWithStatus:GMStatusParseError];
        [weakself executeCompletion:completion withResult:finalResult];
    };
    
    GMCallWebclientLogin *authCall = [[GMCallWebclientLogin alloc] initWithTokens:self.tokens];
    authCall.credentials = crendetials;
    GMCompletionBlock authCompletion = ^(GMResult *result) {
        if (![result isValid]) {
            [weakself executeCompletion:completion withResult:result];
            return;
        }
        
        if (![weakself.tokens fillWithAuthString:result.data]) {
            [weakself executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusParseError]];
            return;
        }
                    
        GMCallWebclientXT *xtCall = [[GMCallWebclientXT alloc] initWithTokens:weakself.tokens];
        [weakself executeCallWithoutAuth:xtCall withCompletion:xtCompletion];
    };
    [weakself executeCallWithoutAuth:authCall withCompletion:authCompletion];
}

- (void)allSongsWithCompletion:(GMCompletionBlock)completion {
    GMCallAllSongs *call = [[GMCallAllSongs alloc] initWithTokens:self.tokens];
    [self executeCall:call withCompletion:completion];    
}

- (void)streamURLForTrackId:(NSString *)trackId completion:(GMCompletionBlock)completion {
    GMCallStreamURLForTrack *call = [[GMCallStreamURLForTrack alloc] initWithTokens:self.tokens];
    call.trackId = trackId;
    [self executeCall:call withCompletion:completion];
}

- (void)listOfUserPlaylists:(GMCompletionBlock)completion {
    GMCall *call = [[GMCallListPlaylists alloc] initWithTokens:self.tokens];
    [self executeCall:call withCompletion:completion];
}

@end
