//
//  SignUpUITest.m
//  TeamUp
//
//  Created by Reno & Jenny on 3/11/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
//#import "MemberDetailViewController.h"

@interface SignUpUITest : XCTestCase

@end

@implementation SignUpUITest

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


- (void)testSignUp {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  //[app.buttons[@"Sign Out"] tap];
  [app.buttons[@"Sign Up"] tap];
  
  XCUIElement *yourUcsdEmailTextField = app.textFields[@"Your UCSD Email"];
  [yourUcsdEmailTextField tap];
  //[yourUcsdEmailTextField typeText:@""];
  [yourUcsdEmailTextField typeText:@"zzzz@ucsd.edu"];
  
  
  XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
  [passwordSecureTextField tap];
  //[passwordSecureTextField tap];
  [passwordSecureTextField typeText:@"12345"];
  
  
  XCUIElement *confirmPasswordSecureTextField = app.secureTextFields[@"Confirm password"];
  [confirmPasswordSecureTextField tap];
  [confirmPasswordSecureTextField typeText:@"12345"];
  
  
  [app.statusBars.element tap];
  [app.buttons[@"Sign Up!"] tap];
  
  XCUIElement *doneButton = app.buttons[@"Done"];
  
  XCTAssertTrue(doneButton.hittable);
  
  
  
  
}

@end
