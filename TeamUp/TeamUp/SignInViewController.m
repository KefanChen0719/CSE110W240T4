//
//  SignInViewController.m
//  TeamUp
//
//  Created by Kefan Chen on 2/15/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "SignInViewController.h"
#import "ForgetPasswordViewController.h"
#import "ViewController.h"
#import <Firebase/Firebase.h>
@interface SignInViewController ()

@end
@implementation SignInViewController
@synthesize emailText, passwordText;

Firebase *firebase1;
Firebase *users_ref1;
Firebase *users1;


//NSString *account;
//NSString *password;


NSString *email1;
NSString *uid1;
NSString *name1;
NSString *year1;
NSString *major1;

UIStoryboard *mainstoryboard1;
UIViewController *viewcontroller1;
UIAlertAction* defaultAction1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailText.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordText setSecureTextEntry:YES];
    UIView *view = self.signInButton.superview;
    CGRect button_frame = self.signInButton.frame;
    CGRect email_frame = self.emailText.frame;
    CGRect password_frame = self.passwordText.frame;
    CGRect label_frame = self.label.frame;
    CGRect signup_frame = self.signUpButton.frame;
    CGRect forget_frame = self.forget.frame;
    button_frame.size.width = view.frame.size.width / 7 * 5;
    button_frame.origin.x = view.frame.size.width / 7;
    button_frame.origin.y = view.frame.size.height / 4 * 3 - button_frame.size.height * 1.5;
    self.signInButton.frame = button_frame;
    email_frame.size.width = view.frame.size.width / 7 * 5;
    email_frame.origin.x = view.frame.size.width / 7;
    email_frame.origin.y = view.frame.size.height / 2 - email_frame.size.height * 2;
    self.emailText.frame = email_frame;
    password_frame.size.width = view.frame.size.width / 7 * 5;
    password_frame.origin.x = view.frame.size.width / 7;
    password_frame.origin.y = email_frame.origin.y + email_frame.size.height + 7;
    self.passwordText.frame = password_frame;
    label_frame.size.width = view.frame.size.width / 5 * 4;
    label_frame.origin.x = view.frame.size.width / 10;
    label_frame.origin.y = view.frame.size.height / 4 - label_frame.size.height / 2;
    self.label.frame = label_frame;
    signup_frame.size.width = view.frame.size.width / 7 * 5;
    signup_frame.origin.x = view.frame.size.width / 7;
    signup_frame.origin.y = button_frame.origin.y + button_frame.size.height + 7;
    self.signUpButton.frame = signup_frame;
    forget_frame.origin.x = view.frame.size.width / 7 * 6 - forget_frame.size.width;
    forget_frame.origin.y = password_frame.origin.y + password_frame.size.height - 3;
    self.forget.frame = forget_frame;
    
    firebase1 = [[Firebase alloc] initWithUrl:@"https://resplendent-inferno-8485.firebaseio.com"];
    defaultAction1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]; //initialize the default alertview action
    mainstoryboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *account = [defaults objectForKey:@"account"];
    NSString *password = [defaults objectForKey:@"password"];
    NSString *signOut = [defaults objectForKey:@"signOut"];
    
    emailText.text = account;
    passwordText.text = password;
    
    if ([signOut isEqualToString:@"False"]){
      [self sign];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadData{
    if(uid1!=nil){
        users1 = [users_ref1 childByAppendingPath:uid1];
        [users1 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if(!snapshot.exists){
                NSLog(@"user info not found");
                return;
            }else{
                name1 = snapshot.value[@"name"];
                //do something
            }
        }];
    }
}

- (IBAction)signIn:(UIButton *)sender {
    [self sign];
    //[self.view endEditing:YES];
}

- (IBAction)signUp:(UIButton *)sender {
    viewcontroller1 = [mainstoryboard1 instantiateViewControllerWithIdentifier:@"signUpViewController"];
    [self presentViewController:viewcontroller1 animated:YES completion:nil];
}

- (IBAction)forgetPassword:(id)sender {
    viewcontroller1 = [mainstoryboard1 instantiateViewControllerWithIdentifier:@"forgetPasswordViewController"];
    [self presentViewController:viewcontroller1 animated:YES completion:nil];
}


- (void) sign {
    [firebase1 authUser:emailText.text password:passwordText.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            NSString *errorMessage = [error localizedDescription];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            email1 = emailText.text;
            uid1 = authData.uid;
            [self loadData];
            
            NSString *account = [emailText text];
            NSString *password  = [passwordText text];
            NSString *signOut  = @"False";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:account forKey:@"account"];
            [defaults setObject:password forKey:@"password"];
            [defaults setObject:signOut forKey:@"signOut"];
        
            [defaults synchronize];
            
            users1 = [users_ref1 childByAppendingPath:uid1];
            [users1 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                name1 = snapshot.value[@"name"];
                year1 = snapshot.value[@"year"];
                major1 = snapshot.value[@"major"];
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
            viewcontroller1 = [mainstoryboard1 instantiateViewControllerWithIdentifier:@"myGroupsViewController"];
            [self presentViewController:viewcontroller1 animated:YES completion:nil];
            NSLog(@"user should have signed in");
        }
    }];
    
}
@end
