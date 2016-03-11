//
//  SignInUiTest.m
//  TeamUp
//
//  Created by Suli Huang on 3/11/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SignInUiTest : XCTestCase

@end

@implementation SignInUiTest

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
    
    XCUIElement *yourUcsdEmailTextField = app.textFields[@"Your UCSD Email"];
    [yourUcsdEmailTextField tap];
    [yourUcsdEmailTextField tap];
    [app.keys[@"delete"] pressForDuration:1.8];
    
    [yourUcsdEmailTextField typeText:@"111@ucsd.edu"];
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField tap];
    [passwordSecureTextField tap];
    [passwordSecureTextField typeText:@"111"];
    [app.statusBars.element tap];
    [app.buttons[@"Sign In"] tap];

    XCUIElement *button = app.buttons[@"CSE110WIN2016  lol"];
    XCTAssert(button.hittable);
}

@end
