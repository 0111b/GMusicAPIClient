//
//  GMWebClient.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMWebClient.h"
//TODO: remove
#import "GMTrackInfo.h"


#import "GMCallListPlaylists.h"
#import "GMCallStreamURLForTrack.h"
#import "GMCallAllSongs.h"

@interface GMWebClient () <NSURLSessionDelegate>
@end

@implementation GMWebClient
- (instancetype) initUniqueInstance {
    self = [super initUniqueInstance];
    if (self) {
        
        self.tokens = [GMSessionTokens new];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = NO;
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    }
    return self;
}

#pragma mark -

- (void)loginWithCredentials:(GMCredentials *)crendetials
                  completion:(GMCompletionBlock)completion {
    if ([self isAuthenticated]) {
        [self logout];
    }
    
    if (!crendetials.username.length || !crendetials.password.length) {
        [self executeCompletion:completion
                     withResult:[GMResult resultWithStatus:GMStatusInvalidArg error:nil]];
        return;
    }
    
    self.credentials = crendetials;
    __weak typeof(*&self)weakself = self;

    void (^xtCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        GMResult *result = nil;
        if (error) {
            result = [GMResult resultWithStatus:GMStatusNetworkError error:error];
        } else {
            NSHTTPCookieStorage *cookieStorage = weakself.session.configuration.HTTPCookieStorage;
            for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
                if ([[cookie name] isEqualToString:@"xt"]) {
                    weakself.tokens.xtToken = [cookie value];
                    GMLog(@"xtToken %@",weakself.tokens.xtToken);
                    break;
                }
            }
            result = [weakself isAuthenticated]?[GMResult resultDone]:[GMResult resultWithStatus:GMStatusParseError error:nil];
        }
        [self executeCompletion:completion withResult:result];
    };
    
    void (^authCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        GMResult *result = nil;
        if (error) {
            result = [GMResult resultWithStatus:GMStatusNetworkError error:error];
        } else {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (![self.tokens fillWithAuthString:string]) {
                result = [GMResult resultWithStatus:GMStatusParseError error:nil];
            } else {
                GMLog(@"authToken : %@", self.tokens.authToken);
                [[weakself.session dataTaskWithRequest:[weakself xtRequest] completionHandler:xtCompletion] resume];
            }
        }
        if (result) {
            [self executeCompletion:completion withResult:result];
        }
    };
    
    
    [[self.session dataTaskWithRequest:[self authRequest] completionHandler:authCompletion] resume];
    
}

- (void)logout {
    self.credentials = nil;
    self.tokens = nil;
}

- (BOOL)isAuthenticated {
    return self.tokens.authToken.length && self.tokens.xtToken.length && self.credentials;
}

#pragma mark -
- (NSURLRequest *)authRequest {
    NSString *postString = [NSString stringWithFormat:@"&Email=%@&Passwd=%@&service=sj",self.credentials.username,self.credentials.password];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/accounts/ClientLogin"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

- (NSURLRequest *)xtRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/listen?u=0"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@",self.tokens.authToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
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
