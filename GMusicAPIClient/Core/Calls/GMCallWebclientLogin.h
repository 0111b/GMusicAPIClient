//
//  GMCallWebclientLogin.h
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCall.h"
#import "GMCredentials.h"
@interface GMCallWebclientLogin : GMCall
@property (nonatomic, strong) GMCredentials *credentials;
@end

@interface GMCallWebclientXT : GMCall

@end