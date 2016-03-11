//
//  AddGroupUITest.m
//  TeamUp
//
//  Created by Suli Huang on 3/11/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AddGroupUITest : XCTestCase

@end

@implementation AddGroupUITest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *window = [[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0];
    [[[[[[window childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    
    XCUIElement *searchHereTextField = app.textFields[@"Search here"];
    [searchHereTextField tap];
    [searchHereTextField typeText:@"c"];
    [app.tables.staticTexts[@"CSE 100"] tap];
    [[[[[[[window childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    
    XCUIElement *groupNameTextField = app.textFields[@"Group name"];
    [groupNameTextField tap];
    [groupNameTextField typeText:@"qqq"];
    
    XCUIElement *maxPeopleTextField = app.textFields[@"Max people"];
    [maxPeopleTextField tap];
    [maxPeopleTextField typeText:@"2"];
    
    XCUIElement *switch2 = app.switches[@"1"];
    [switch2 tap];
    [app.buttons[@"Create"] tap];
    [app.alerts[@"Yeah!"].collectionViews.buttons[@"OK"] tap];
    
    XCUIElement *button = app.buttons[@"qqq"];
    XCTAssert(button.hittable);}

@end
