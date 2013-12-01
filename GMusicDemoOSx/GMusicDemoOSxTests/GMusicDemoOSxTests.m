//
//  GMusicDemoOSxTests.m
//  GMusicDemoOSxTests
//
//  Created by Alexandr Goncharov on 12/1/13.
//  Copyright (c) 2013 Alexandr Goncharov. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GMusicDemoOSxTests : XCTestCase

@end

@implementation GMusicDemoOSxTests

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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"user" withExtension:@"plist"];
    XCTAssertNotNil(url, @"error locating credentials");
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    XCTAssertNotNil(d[@"username" ], @"parsing error");
    XCTAssertNotNil(d[@"password"], @"parsing error");
}

@end
