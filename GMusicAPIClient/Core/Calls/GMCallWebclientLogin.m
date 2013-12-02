//
//  GMCallWebclientLogin.m
//  GMusicAPIClient
//
//  Created by Alexandr Goncharov on 12/2/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "GMCallWebclientLogin.h"

@implementation GMCallWebclientLogin
- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    if (self.credentials) {
        NSString *postString = [NSString stringWithFormat:@"&Email=%@&Passwd=%@&service=sj",self.credentials.username,self.credentials.password];
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/accounts/ClientLogin"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }

    return request;
}

- (GMResult *)processData:(NSData *)data withResponse:(NSURLResponse *)response {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [GMResult resultWithData:string];
}

@end


@implementation GMCallWebclientXT

- (NSMutableURLRequest *)request {
    NSMutableURLRequest *request = [super request];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/listen?u=0"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (GMResult *)processData:(NSData *)data withResponse:(NSURLResponse *)response {
    return [GMResult resultDone];
}

@end
