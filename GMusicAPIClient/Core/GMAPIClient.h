//
//  GMusicBaseClient.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMResult.h"
@class GMCredentials;
@class GMTrackInfo;

@interface GMAPIClient : NSObject

#pragma mark - Singleton -

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

#pragma mark -

- (void)loginWithCredentials:(GMCredentials *)crendetials completion:(GMCompletionBlock)completion;
- (BOOL)isAuthenticated;
- (void)logout;

- (void)allSongsWithCompletion:(GMCompletionBlock)completion;
- (void)streamURLForTrack:(GMTrackInfo *)track completion:(GMCompletionBlock)completion;
@end
