//
//  AppDelegate.m
//  GMusicDemoOSx
//
//  Created by Alexandr Goncharov on 12/1/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "AppDelegate.h"
#import <GMusicAPIClient.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)loginTouched:(id)sender {
    NSString *username = @"username";
    NSString *password = @"thyifbvzvwkmngyc";
    
    [[GMWebClient sharedInstance] loginWithCredentials:[GMCredentials credentialsWithUsername:username password:password] completion:^(GMResult *result) {
        NSLog(@"Login %lu",result.status);
        if ([result isValid]) {
            NSLog(@"Logged in");
        } else {
            NSLog(@"Fail");
        }
    }];
}

@end
