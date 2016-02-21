//
//  ForgetPasswordViewController.h
//  TeamUp
//
//  Created by Shuyu Gu on 2/20/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ForgetPasswordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;

- (IBAction)back:(UIButton *)sender;
- (IBAction)resetPassword:(UIButton *)sender;


@end
