//
//  GMusicBaseClient+Protected.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMAPIClient.h"
#import "GMCredentials.h"
#import "GMSessionTokens.h"
#import "GMCall.h"

@interface GMAPIClient ()

- (instancetype) initUniqueInstance;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) GMSessionTokens *tokens;

@property (nonatomic, strong) GMCredentials *credentials;

- (void)executeCall:(GMCall *)call withCompletion:(GMCompletionBlock)completion;
- (void)executeCompletion:(GMCompletionBlock)completion withResult:(GMResult *)result;
@end


@interface GMAPIClient (SyntaxSugar)

@end