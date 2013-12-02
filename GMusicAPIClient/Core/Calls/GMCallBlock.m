//
//  GMCallBlock.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallBlock.h"

@implementation GMCallBlock
- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    if (self.updateRequestBlock) {
        request = self.updateRequestBlock(request);
    }
    return request;
}
- (GMResult *)processData:(NSData *)data withResponse:(NSURLResponse *)response {
    if (self.progressBlock) {
        return self.progressBlock(data,response);
    } else {
        return [super processData:data withResponse:response];
    }    
}
@end
