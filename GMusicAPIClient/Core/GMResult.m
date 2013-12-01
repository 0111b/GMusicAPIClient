//
//  GMResult.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMResult.h"

@interface NSError (GMusicAPI)
+ (NSError *)errorWithStatus:(GMStatus)status;
@end

#pragma mark -

@implementation GMResult

+ (instancetype)resultDone {
    return [[GMResult alloc] initWithStatus:GMStatusOk error:nil data:nil];
}

+ (instancetype)resultWithStatus:(GMStatus)status {
    return [[GMResult alloc] initWithStatus:status error:nil data:nil];
}

+ (instancetype)resultWithStatus:(GMStatus)status error:(NSError *)error {
    return [[GMResult alloc] initWithStatus:status error:error data:nil];
}

+ (instancetype)resultWithData:(id)data {
    return [[GMResult alloc] initWithStatus:GMStatusOk error:nil data:data];
}

- (id)initWithStatus:(GMStatus)status error:(NSError *)error data:(id)data{
    self = [super init];
    if (self) {
        self.status = status;
        self.error = error;
        self.data = data;
    }
    return self;
}

- (NSError *)error {
    if (self->_error) {
        return self->_error;
    } else {
        return [NSError errorWithStatus:self.status];
    }
}

- (BOOL)isValid {
    return self.status == GMStatusOk;
}
@end

#pragma mark -

NSString *const kGMusicAPIErrorDomain = @"kGMusicAPIErrorDomain";

@implementation NSError (GMusicAPI)

+ (NSError *)errorWithStatus:(GMStatus)status {
    NSString *localizedMessage = @"";
    //TODO: implement error generation
    switch (status) {
        default:
            break;
    }
    NSError *error = nil;
    if (status != GMStatusOk) {
        error = [NSError errorWithDomain:kGMusicAPIErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey : localizedMessage }];
    }
    return error;
}

@end
