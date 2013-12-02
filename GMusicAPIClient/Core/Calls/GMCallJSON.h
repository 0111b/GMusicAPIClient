//
//  GMCallJSON.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCall.h"

@interface GMCallJSON : GMCall
- (GMResult *)processJSON:(id)json withResponse:(NSURLResponse *)response;
@end
