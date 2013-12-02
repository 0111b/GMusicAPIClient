//
//  GMCallJSON.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallJSON.h"

@implementation GMCallJSON

- (GMResult *)processData:(NSData *)data {
    NSError *parseError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
    if (parseError) {
        return   [GMResult resultWithStatus:GMStatusParseError error:parseError];
    } else {
        return [self processJSON:json];
    }
}

- (GMResult *)processJSON:(id)json {
    return [GMResult resultWithData:json];
}
@end
