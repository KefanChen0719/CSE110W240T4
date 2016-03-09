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

@interface MemberDetailViewController : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;
@property (weak, nonatomic) IBOutlet UIScrollView *TeamMemberScrollView;
- (IBAction)quitGroup:(id)sender;
@end
#endif /* MemberDetailViewController_h */
