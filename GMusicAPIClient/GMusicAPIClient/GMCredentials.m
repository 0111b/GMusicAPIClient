//
//  GMCredentials.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCredentials.h"

@implementation GMCredentials
+ (instancetype)credentialsWithUsername:(NSString *)uname password:(NSString *)pwd {
    GMCredentials *credentials = [[GMCredentials alloc] init];
    credentials->_username = [uname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    credentials->_password = [pwd  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return credentials;
}
@end
