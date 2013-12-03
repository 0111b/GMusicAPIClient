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

@end

BOOL isTravis() {
    char *travis = getenv("TRAVIS");
    BOOL isTravis = (travis && (strcmp(travis, "true") == 0));
    isTravis |= ([[NSProcessInfo processInfo] environment][@"TRAVIS"] != nil);
    return isTravis;
}

#define GM_DISABLE_ON_TRAVIS if(isTravis()) return


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
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    GM_DISABLE_ON_TRAVIS;
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
    GM_DISABLE_ON_TRAVIS;
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
