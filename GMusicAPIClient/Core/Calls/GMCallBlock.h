//
//  GMCallBlock.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCall.h"

typedef GMResult *(^GMCallProcessBlock)(NSData *, NSURLResponse *);
typedef NSMutableURLRequest *(^GMCallUpdateRequestBlock)(NSMutableURLRequest *);
@interface GMCallBlock : GMCall
@property (nonatomic, copy) GMCallUpdateRequestBlock updateRequestBlock;
@property (nonatomic, copy) GMCallProcessBlock progressBlock;
@end
