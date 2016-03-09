//
//  GroupMemberDetails.m
//  TeamUp
//
//  Created by Suli Huang on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupMemberDetails.h"

@interface GroupMemberDetails ()

@end

@implementation GroupMemberDetails
@synthesize appDelegate,viewcontroller;

- (void)viewDidLoad{
    _nameLabel.text = @"hello";
    _majorLabel.text = @"hello";
    _yearLabel.text = @"hello";
}

- (void)groupmemberDetailsLayout {
    UIView *view = self.accountLabel.superview;
    CGRect view_frame = view.frame;
    CGRect topView_frame = self.topView1.frame;
    topView_frame.size.width = view_frame.size.width;
    self.topView1.frame = topView_frame;
    CGRect update_frame = self.nameLabel.frame;
    update_frame.origin.x = view_frame.size.width - update_frame.size.width - 10;
    self.nameLabel.frame = update_frame;
    CGRect label_frame = self.accountLabel.frame;
    label_frame.origin.x = view_frame.size.width / 4;
    label_frame.size.width = view_frame.size.width / 2;
    label_frame.origin.y = view_frame.size.height / 5;
    self.accountLabel.frame = label_frame;
    CGRect nameText_frame = self.nameLabel.frame;
    nameText_frame.origin.x = view_frame.size.width / 2;
    self.nameLabel.frame = nameText_frame;
    CGRect majorText_frame = self.majorLabel.frame;
    majorText_frame.origin.x = view_frame.size.width / 2;
    self.majorLabel.frame = majorText_frame;
    CGRect yearText_frame = self.yearLabel.frame;
    yearText_frame.origin.x = view_frame.size.width / 2;
    self.yearLabel.frame = yearText_frame;
   }
@end