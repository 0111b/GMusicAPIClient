//
//  GMCall.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMResult.h"
#import "GMSessionTokens.h"

@interface GMCall : NSObject
- (id)initWithTokens:(GMSessionTokens *)tokens;
- (NSMutableURLRequest *)request;
- (GMResult *)processData:(NSData *)data;

@property (nonatomic, strong, readonly) GMSessionTokens *usedTokens;
@end


@protocol GMCall <NSObject>
+(instancetype) alloc;
@end