//
//  GMWebClient.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMAPIClient+Protected.h"

@interface GMWebClient : GMAPIClient
- (void)listOfUserPlaylists:(GMCompletionBlock)completion;
@end
