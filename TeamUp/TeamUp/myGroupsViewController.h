//
//  myGroupsViewController.h
//  TeamUp
//
//  Created by Jiasheng Zhu on 2/24/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef myGroupsViewController_h
#define myGroupsViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TeamUp-Swift.h"

@interface myGroupsViewController : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *signOut;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (strong, nonatomic) UIViewController *viewcontroller;
- (IBAction)signOut:(id)sender;

- (NSString *) getNameFromGroupUid:(NSString*) group_uid;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end

#endif /* myGroupsViewController_h */
