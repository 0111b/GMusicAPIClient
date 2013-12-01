//
//  GMCredentials.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMCredentials : NSObject
+ (instancetype)credentialsWithUsername:(NSString *)uname password:(NSString *)password;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;
@end
