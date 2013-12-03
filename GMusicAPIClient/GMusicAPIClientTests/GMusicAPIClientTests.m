//
//  GMusicAPIClientTests.m
//  GMusicAPIClientTests
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+AsyncTesting.h"
#import "GMusicAPIClient.h"

@interface GMusicAPIClientTests : XCTestCase
@property (nonatomic, assign) BOOL isTestsDisabled;
@end



BOOL testAreDisabled() {
    NSURL *url = [NSURL URLWithString:@"user.plist" relativeToURL:[[NSBundle bundleForClass:[GMusicAPIClientTests class]] resourceURL]];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    return  [d[@"disableTests"] boolValue];
}

GMCredentials *testCredentials() {
    NSURL *url = [NSURL URLWithString:@"user.plist" relativeToURL:[[NSBundle bundleForClass:[GMusicAPIClientTests class]] resourceURL]];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    return [GMCredentials credentialsWithUsername:d[@"username" ]
                                         password:d[@"password"]];
}

@implementation GMusicAPIClientTests

- (void)setUp
{
    [super setUp];
    self.isTestsDisabled = testAreDisabled();
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1DefaultCredentialsLocation {
    GMCredentials *credentials = testCredentials();
    XCTAssertNotNil(credentials.username, @"parsing error");
    XCTAssertNotNil(credentials.password, @"parsing error");
}

- (void)test2WebClientInit {
    XCTAssertNotNil([GMWebClient sharedInstance], @"Error creating singleton");
}

- (void)test3Login {
    if (self.isTestsDisabled) return;
    [[GMWebClient sharedInstance] loginWithCredentials:testCredentials()
                                            completion:^(GMResult *result) {
                                                if ([result isValid]) {
                                                    [self notify:XCTAsyncTestCaseStatusSucceeded];
                                                } else {
                                                    [self notify:XCTAsyncTestCaseStatusFailed];
                                                }
                                            }];
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.];
    XCTAssertTrue([[GMWebClient sharedInstance] isAuthenticated], @"invalid auth status");
}

- (void)test4ListOfUserPlaylist {
    if (self.isTestsDisabled) return;
    [[GMWebClient sharedInstance] listOfUserPlaylists:^(GMResult *result) {
                                                if ([result isValid]) {
                                                    NSLog(@"data:%@",result.data);
                                                    [self notify:XCTAsyncTestCaseStatusSucceeded];
                                                } else {
                                                    [self notify:XCTAsyncTestCaseStatusFailed];
                                                }
                                            }];
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.];
}

@end
