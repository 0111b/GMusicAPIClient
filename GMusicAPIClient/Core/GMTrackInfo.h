//
//  GMTrackInfo.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/1/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 {
 "artistImageBaseUrl":"\/\/lh4.googleusercontent.com\/np88QpQBa4eR1ZE-Loonr9OqSWprgJ5JlnsWvdgP0Hq9tOlX-r22JfTTVaZc-BJ-CWYELydcWA",
 "id":"cf5a6146-69ed-3907-9b72-d4fa1274ce5d",
 "playCount":3,
 "genre":"visual kei",
 "curatedByUser":false,
 "durationMillis":190000,
 "url":"",
 "albumArtUrl":"\/\/lh5.googleusercontent.com\/aeoeki-XCVghWCA9rc2erOWhoVpdRdLAQRJcirQGquE9PO7cKmUq6b2NHi6g9A=s130-c-e100",
 "year":2007,
 "artistNorm":"-oz-",
 "comment":"",
 "totalTracks":0,
 "type":2,
 "albumArtist":"-OZ-",
 "curationSuggested":false,
 "album":"SIX",
 "bitrate":320,
 "totalDiscs":0,
 "recentTimestamp":1354116785961000,
 "name":"Enmity",
 "lastPlaybackTimestamp":1373551370668000,
 "albumNorm":"six",
 "albumArtistNorm":"-oz-",
 "lastPlayed":1354116785970244,
 "composer":"",
 "deleted":false,
 "artistMatchedId":"Afb2quyb262jn44zqlypw3lxbmm",
 "titleNorm":"enmity",
 "creationDate":1354116769460959,
 "subjectToCuration":false,
 "beatsPerMinute":0,
 "artist":"-OZ-",
 "title":"Enmity",
 "track":6,
 "rating":0,
 "disc":0,
 "origin":
 [
 ]
 },
 
 
 */



@interface GMTrackInfo : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *trackID;
@property (nonatomic, copy) NSString *artistImageBaseUrl;
@property (nonatomic, copy) NSString *albumArtUrl;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSNumber *year;
@end
