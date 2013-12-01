//
//  GMusicAPIClientTests.m
//  GMusicAPIClientTests
//
//  Created by Alexandr Goncharov on 11/30/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GMusicAPIClient.h"

@interface GMusicAPIClientTests : XCTestCase

@end

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

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testWebClientInit {
    XCTAssertTrue([GMWebClient sharedInstance], @"Error creating singleton");
}


- (void)testWebClientLogin {
    GMCredentials *cred = [GMCredentials credentialsWithUsername:@"u" password:@"p"];
    [[GMWebClient sharedInstance] loginWithCredentials:cred completion:nil];
    XCTAssertTrue([[GMWebClient sharedInstance] isAuthenticated], @"Auth failed");
}
@end
