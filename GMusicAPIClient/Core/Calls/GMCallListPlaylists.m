//
//  GMListRegisteredDeviceCall.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallListPlaylists.h"
#import "GMPlaylistInfo.h"

@implementation GMCallListPlaylists
- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/sj/v1.1/playlistfeed?alt=json&include-tracks=true"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[@"{'alt': 'json', 'include-tracks': 'true'}" dataUsingEncoding:NSUTF8StringEncoding]];

    return request;
}

- (GMResult *)processJSON:(id)json withResponse:(NSURLResponse *)response {
    NSArray *rawArray = [json valueForKeyPath:@"data.items"];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] initWithCapacity:[rawArray count]];
    for (NSDictionary *rawItem in rawArray) {
        GMPlaylistInfo *item = [[GMPlaylistInfo alloc] initWithDictionary:rawItem];
        [itemsArray addObject:item];
    }
    return [GMResult resultWithData:itemsArray];
}
@end
