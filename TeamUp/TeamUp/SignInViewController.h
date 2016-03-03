//
//  SignInViewController.h
//  TeamUp
//
//  Created by Kefan Chen on 2/15/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SignInViewController : UIViewController //<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *forget;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

- (IBAction)signIn:(UIButton *)sender;
- (IBAction)signUp:(UIButton *)sender;
- (IBAction)forgetPassword:(UIButton *)sender;

@end