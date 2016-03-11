//
//  TeamUpTests.m
//  TeamUpTests
//
//  Created by Reno & Jenny on 1/26/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ClassGroupsViewController.h"


@interface TeamUpTests : XCTestCase

@end

@implementation TeamUpTests

- (void)setUp {
  [super setUp];
}


// unit test for getNameFromGroupUid in ClassGroupsViewController
- (void)testGetGroupName {
  
  // initialize view controller object
  ClassGroupsViewController *vc = [[ClassGroupsViewController alloc] init];
  
  // call the method to get the substring of group uid
  NSString *result = [vc getNameFromGroupUid:@"921eb1c8-50e1-4628-8e7b-9bd0d7d7fe12testGroup"];
  
  // compare the result with the correct result
  XCTAssertEqualObjects(result, @"testGroup");
}


@end
