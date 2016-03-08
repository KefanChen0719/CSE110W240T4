//
//  UIViewController+AddGroupViewController.h
//  TeamUp
//
//  Created by Ryan Li on 3/3/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef AddGroupViewController_h
#define AddGroupViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddGroupViewController : UIViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *add;

- (NSString *) getNameFromGroupUid:(NSString*) group_uid;

@end

#endif
