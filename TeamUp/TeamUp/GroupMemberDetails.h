//
//  GroupMemberDetails.h
//  TeamUp
//
//  Created by Suli Huang on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#ifndef GroupMemberDetails_h
#define GroupMemberDetails_h
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TeamUp-Swift.h"
@interface GroupMemberDetails : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *majorLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIView *topView1;
@property (strong, nonatomic) UIViewController *viewcontroller;
@end;
#endif /* GroupMemberDetails_h */
