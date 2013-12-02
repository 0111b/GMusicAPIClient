//
//  GMSession.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMSessionTokens.h"

@implementation GMSessionTokens
- (BOOL)fillWithAuthString:(NSString *)authString {
    NSMutableDictionary *authDictionary = [NSMutableDictionary dictionary];
    NSArray *rawArray = [authString componentsSeparatedByString:@"\n"];
    for (NSString *row in rawArray) {
        NSArray *keyValueArray = [row componentsSeparatedByString:@"="];
        if ([keyValueArray count] != 2) {
            continue;
        }
        authDictionary[keyValueArray[0]] = keyValueArray[1];
    }
    
    NSString *authToken = authDictionary[@"Auth"];
    
    if (!authToken) {
        return NO;
    }
    self.authToken = authToken;
    return YES;
}
@end
