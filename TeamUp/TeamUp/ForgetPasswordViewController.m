//
//  ForgetPasswordViewController.m
//  TeamUp
//
//  Created by Shuyu Gu on 2/20/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ViewController.h"
#import "SignInViewController.h"
#import <Firebase/Firebase.h>

@interface ForgetPasswordViewController ()

@end

Firebase *firebase2;
UIStoryboard *mainstoryboard2;
UIViewController *viewcontroller2;

@implementation ForgetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIView *view = self.upperView.superview;
    CGRect view_frame = view.frame;
    CGRect upperView_frame = self.upperView.frame;
    upperView_frame.size.width = view_frame.size.width;
    self.upperView.frame = upperView_frame;
    CGRect topLabel_frame = self.topLabel.frame;
    topLabel_frame.origin.x = view_frame.size.width / 5;
    topLabel_frame.size.width = view_frame.size.width / 5 * 3;
    self.topLabel.frame = topLabel_frame;
    CGRect label1_frame = self.label1.frame;
    label1_frame.origin.x = 0;
    label1_frame.size.width = view_frame.size.width;
    self.label1.frame = label1_frame;
    CGRect label2_frame = self.label2.frame;
    label2_frame.origin.x = 0;
    label2_frame.size.width = view_frame.size.width;
    self.label2.frame = label2_frame;
    CGRect sendButton_frame = self.sendButton.frame;
    sendButton_frame.origin.x = view_frame.size.width - sendButton_frame.size.width - 10;
    self.sendButton.frame = sendButton_frame;
    
    firebase2 = [[Firebase alloc] initWithUrl:@"https://resplendent-inferno-8485.firebaseio.com"];
    mainstoryboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIButton *)sender {
    viewcontroller2 = [mainstoryboard2 instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:viewcontroller2 animated:YES completion:nil];
}

- (IBAction)resetPassword:(UIButton *)sender {
    [firebase2 resetPasswordForUser:self.emailText.text withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error when resetting password");
            [self.emailText setText:@"error occured"];
        } else {
            NSLog(@"succeed sending resetting password");
            [self.emailText setText:@"sent"];
        }
    }];
}
@end
