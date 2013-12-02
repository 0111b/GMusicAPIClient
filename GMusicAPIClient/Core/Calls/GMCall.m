//
//  GMCall.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCall.h"

@interface GMCall ()
@property (nonatomic, strong) NSMutableURLRequest *callRequest;
@end

@implementation GMCall
- (id)initWithTokens:(GMSessionTokens *)tokens {
    if (self = [super init]) {
        self->_usedTokens = tokens;
        self.callRequest = [[NSMutableURLRequest alloc] init];
        if (tokens) {
            [self.callRequest setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@",tokens.authToken] forHTTPHeaderField:@"Authorization"];
        }
    }
    return self;
}

- (NSMutableURLRequest *)request {
    return self.callRequest;
}

- (GMResult *)processData:(NSData *)data {
    return [GMResult resultWithData:data];
}

@end
