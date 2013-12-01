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

- (void)testDefaultCredentials {
    NSURL *url = [NSURL URLWithString:@"user.plist" relativeToURL:[[NSBundle bundleForClass:[self class]] resourceURL]];
    XCTAssertNotNil(url, @"error locating credentials");
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    XCTAssertNotNil(d[@"username" ], @"parsing error");
    XCTAssertNotNil(d[@"password"], @"parsing error");
}

- (void)testWebClientInit {
    XCTAssertNotNil([GMWebClient sharedInstance], @"Error creating singleton");
}


@end
