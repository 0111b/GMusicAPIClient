//
//  GMWebClient.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMWebClient.h"
#import "GMTrackInfo.h"

@interface GMWebClient () <NSURLSessionDelegate>
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *xtToken;
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
                    weakself.xtToken = [cookie value];
                    GMLog(@"xtToken %@",weakself.xtToken);
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
            NSArray *respArray = [string componentsSeparatedByString:@"\n"];
            if ([respArray count] <3) {
                result = [GMResult resultWithStatus:GMStatusParseError error:nil];
            } else {
                string = [respArray objectAtIndex:2];
                string = [string stringByReplacingOccurrencesOfString:@"Auth=" withString:@""];
                //NSLog(response);
                weakself.authToken = string;
                GMLog(@"authToken : %@", self.authToken);
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
    self.authToken = nil;
    self.xtToken = nil;
}

- (BOOL)isAuthenticated {
    return self.authToken.length && self.xtToken.length && self.credentials;
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
    [request setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@",self.authToken] forHTTPHeaderField:@"Authorization"];
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
    if (![self isAuthenticated]) {
        [self executeCompletion:completion withResult:[GMResult resultWithStatus:GMStatusInvalidCredentials]];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/services/loadalltracks?u=0&xt=%@",self.xtToken]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@",self.authToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    void (^requestCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        GMResult *result = nil;
        if (error) {
            result = [GMResult resultWithStatus:GMStatusNetworkError error:error];
        } else {
            NSError *parseError = nil;
            NSDictionary *songsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError) {
                result = [GMResult resultWithStatus:GMStatusParseError error:parseError];
            } else {
                NSArray *rawArray = songsDictionary[@"playlist"];
                NSMutableArray *songsArray = [[NSMutableArray alloc] initWithCapacity:[songsDictionary count]];
                for (NSDictionary *rawSong in rawArray) {
                    GMTrackInfo *track = [[GMTrackInfo alloc] initWithDictionary:rawSong];
                    [songsArray addObject:track];
                }
                result = [GMResult resultWithData:songsArray];
            }
        }
        if (result) {
            [self executeCompletion:completion withResult:result];
        }
    };
    [[self.session dataTaskWithRequest:request completionHandler:requestCompletion] resume];
}

- (void)streamURLForTrack:(GMTrackInfo *)track completion:(GMCompletionBlock)completion {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/play?u=0&songid=%@&pt=e",track.trackID]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@",self.authToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    void (^requestCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        GMResult *result = nil;
        if (error) {
            result = [GMResult resultWithStatus:GMStatusNetworkError error:error];
        } else {
            NSError *parseError = nil;
            NSDictionary *urlDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError) {
                result = [GMResult resultWithStatus:GMStatusParseError error:parseError];
            } else {
                NSString *urlString = urlDictionary[@"url"];
                if (urlString) {
                    result = [GMResult resultWithData:[NSURL URLWithString:urlString]];
                } else {
                    result = [GMResult resultWithStatus:GMStatusParseError];
                }
            }
        }
        if (result) {
            [self executeCompletion:completion withResult:result];
        }
    };
    
    [[self.session dataTaskWithRequest:request completionHandler:requestCompletion] resume];
}

@end
