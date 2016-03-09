//
//  MemberDetailViewController.h
//  TeamUp
//
//  Created by Jiasheng Zhu on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef MemberDetailViewController_h
#define MemberDetailViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TeamUp-Swift.h"
#import "UIImage+MDQRCode.h"
@interface MemberDetailViewController : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *GroupNameLabel;
- (IBAction)quitGroup:(id)sender;
- (IBAction)UpdateGroupInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backToChatButton;
- (void) backToChat:(id) chat;
@end
#endif /* MemberDetailViewController_h */
