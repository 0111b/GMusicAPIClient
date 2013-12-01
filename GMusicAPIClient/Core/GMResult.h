//
//  GMResult.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GMStatus) {
    
    GMStatusOk                  =  200,
    
    GMStatusConsistencyError    =  101,
    GMStatusInvalidCredentials  =  102,
    GMStatusInvalidArg          =  103,
    
    
    GMStatusNetworkError        =  401,
    GMStatusParseError          =  402,
};

FOUNDATION_EXPORT NSString *const kGMusicAPIErrorDomain;

@interface GMResult : NSObject
+ (instancetype)resultDone;
+ (instancetype)resultWithStatus:(GMStatus)status;
+ (instancetype)resultWithStatus:(GMStatus)status error:(NSError *)error;
+ (instancetype)resultWithData:(id)data;

@property (nonatomic, assign) GMStatus status;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id data;

- (BOOL)isValid;
@end

typedef void(^GMCompletionBlock)(GMResult *result);