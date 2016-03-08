//
//  SignUpViewController.m
//  TeamUp
//
//  Created by Kefan Chen on 2/21/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "SignUpViewController.h"
#import "ForgetPasswordViewController.h"
#import "ViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"

#import <Firebase/Firebase.h>

@interface SignUpViewController ()

@end

NSString *email3;
NSString *year3;
NSString *major3;

@implementation SignUpViewController
@synthesize appDelegate, viewcontroller;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailText.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordText setSecureTextEntry:YES];
    self.confirmPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.confirmPasswordText setSecureTextEntry:YES];
    
    UIView *view = self.label.superview;
    CGRect view_frame = view.frame;
    CGRect label_frame = self.label.frame;
    label_frame.size.width = view_frame.size.width / 5 * 4;
    label_frame.origin.x = view_frame.size.width / 10;
    label_frame.origin.y = view_frame.size.height / 4 - label_frame.size.height / 2;
    self.label.frame = label_frame;
    CGRect emailText_frame = self.emailText.frame;
    emailText_frame.size.width = view_frame.size.width / 7 * 5;
    emailText_frame.origin.x = view_frame.size.width / 7;
    emailText_frame.origin.y = view_frame.size.height * 0.35;
    self.emailText.frame = emailText_frame;
    CGRect passwordText_frame = self.passwordText.frame;
    passwordText_frame.size.width = view_frame.size.width / 7 * 5;
    passwordText_frame.origin.x = view_frame.size.width / 7;
    passwordText_frame.origin.y = view_frame.size.height / 2;
    self.passwordText.frame = passwordText_frame;
    CGRect confirmPasswordText_frame = self.confirmPasswordText.frame;
    confirmPasswordText_frame.size.width = view_frame.size.width / 7 * 5;
    confirmPasswordText_frame.origin.x = view_frame.size.width / 7;
    confirmPasswordText_frame.origin.y = passwordText_frame.origin.y + passwordText_frame.size.height + 5;
    self.confirmPasswordText.frame = confirmPasswordText_frame;
    CGRect signUp_frame = self.signUpButton.frame;
    signUp_frame.size.width = view_frame.size.width / 7 * 5;
    signUp_frame.origin.x = view_frame.size.width / 7;
    signUp_frame.origin.y = view_frame.size.height / 4 * 3;
    self.signUpButton.frame = signUp_frame;
    CGRect back_frame = self.backButton.frame;
    back_frame.size.width = view_frame.size.width / 7 * 5;
    back_frame.origin.x = view_frame.size.width / 7;
    back_frame.origin.y = signUp_frame.origin.y + signUp_frame.size.height + 10;
    self.backButton.frame = back_frame;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)back:(UIButton *)sender {
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (IBAction)signUp:(UIButton *)sender {
    NSString * domain = [self.emailText.text substringFromIndex:MAX((int)[self.emailText.text length]-8, 0)];
    if (![domain isEqualToString:@"ucsd.edu"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must use a ucsd email!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:appDelegate.defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if(![self.passwordText.text isEqualToString:self.confirmPasswordText.text]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Different passwords" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:appDelegate.defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        self.passwordText.text = @"";
        self.confirmPasswordText.text = @"";
        return;
    }
    else{
        [appDelegate.firebase createUser:self.emailText.text password:self.passwordText.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error) {
                NSString *errorMessage = [error localizedDescription];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:appDelegate.defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [appDelegate.firebase authUser:self.emailText.text password:self.passwordText.text withCompletionBlock:nil];
                email3 = self.emailText.text;
                appDelegate.uid = result[@"uid"];
                [appDelegate loadData];
                appDelegate.name = @"new user";
                appDelegate.email = self.emailText.text;
                major3 = @"undecided";
                year3 = @"0";
                NSDictionary *user_info = @{
                                            @"name" : appDelegate.name,
                                            @"email" : email3,
                                            @"major" : major3,
                                            @"year" : year3
                                            };
                NSDictionary *new_user = @{appDelegate.uid : user_info};
                [appDelegate.users_ref updateChildValues:new_user];
                NSLog(@"user should have signed up");
                viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"memberDetailsViewController"];
                [self presentViewController:viewcontroller animated:YES completion:nil];
            }
        }];
    }
}

@end
