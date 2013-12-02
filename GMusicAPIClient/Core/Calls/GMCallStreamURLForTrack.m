//
//  GMCallStreamURLForTrack.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallStreamURLForTrack.h"

@implementation GMCallStreamURLForTrack
- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/play?u=0&songid=%@&pt=e",self.trackId]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];    
    return request;
}

- (GMResult *)processJSON:(id)json withResponse:(NSURLResponse *)response {
    NSString *urlString = json[@"url"];
    if (urlString) {
        return [GMResult resultWithData:[NSURL URLWithString:urlString]];
    } else {
        return  [GMResult resultWithStatus:GMStatusParseError];
    }
}

@end
