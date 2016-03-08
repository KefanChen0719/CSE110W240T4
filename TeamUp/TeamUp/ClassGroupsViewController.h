//
//  ClassGroupsViewController.h
//  TeamUp
//
//  Created by Jiasheng Zhu on 3/02/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef ClassGroupsViewController_h
#define ClassGroupsViewController_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ClassGroupsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIViewController *viewcontroller;
//@property (weak, nonatomic) IBOutlet UILabel *CourseLabel;
//@property (weak, nonatomic) IBOutlet UIButton *AddButton;
//@property (weak, nonatomic) IBOutlet UIButton *BackButton;

- (NSString *) getNameFromGroupUid:(NSString*) group_uid;

@end

#endif /* ClassGroupsViewController_h */