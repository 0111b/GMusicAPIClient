//
//  ViewController.m
//  GMusicDemoiOS
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import "LoginViewController.h"
#import <GMusicAPIClient.h>



@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTouched:(id)sender {
    NSString *username = @"username";
    NSString *password = @"thyifbvzvwkmngyc";
    
    [[GMWebClient sharedInstance] loginWithCredentials:[GMCredentials credentialsWithUsername:username password:password] completion:^(GMResult *result) {
        NSLog(@"Login %d",result.status);
        if ([result isValid]) {
            [self performSegueWithIdentifier:@"ShowPlaylistSegue" sender:self];
        }
    }];
}

@end
