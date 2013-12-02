//
//  GMSession.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSessionTokens : NSObject
- (BOOL)fillWithAuthString:(NSString *)authString;

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *xtToken;
@end
