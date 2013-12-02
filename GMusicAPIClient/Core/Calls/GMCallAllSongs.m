//
//  GMCallAllSongs.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallAllSongs.h"
#import "GMTrackInfo.h"

@implementation GMCallAllSongs
- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/services/loadalltracks?u=0&xt=%@",self.usedTokens.xtToken]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (GMResult *)processJSON:(id)json {
    NSArray *rawArray = json[@"playlist"];
    NSMutableArray *songsArray = [[NSMutableArray alloc] initWithCapacity:[rawArray count]];
    for (NSDictionary *rawSong in rawArray) {
        GMTrackInfo *track = [[GMTrackInfo alloc] initWithDictionary:rawSong];
        [songsArray addObject:track];
    }
    return [GMResult resultWithData:songsArray];
}
@end
