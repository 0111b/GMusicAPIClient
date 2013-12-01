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
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GMCredentials *credentials = [GMCredentials defaultCredentials];
    self.loginTextField.text = credentials.username;
    self.passwordTextField.text = credentials.password;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTouched:(id)sender {
    GMCredentials *credentials = [GMCredentials credentialsWithUsername:self.loginTextField.text
                                                               password:self.passwordTextField.text];
    [[GMWebClient sharedInstance] loginWithCredentials:credentials completion:^(GMResult *result) {
        NSLog(@"Login %d",result.status);
        if ([result isValid]) {
            [self performSegueWithIdentifier:@"ShowPlaylistSegue" sender:self];
        }
    }];
}

@end
