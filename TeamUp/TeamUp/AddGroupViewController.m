//
//  UIViewController+AddGroupViewController.m
//  TeamUp
//
//  Created by Ryan Li on 3/3/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "AddGroupViewController.h"
#import "UIImage+MDQRCode.h"

@interface AddGroupViewController ()

@end


@implementation AddGroupViewController
@synthesize appDelegate,viewcontroller;

NSString *group_uid;
NSString* QR_UID;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    
    //Group name label setting
    UILabel *groupName = [[UILabel alloc] init];
    [groupName setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/16 * 2,200,30)];
    groupName.backgroundColor=[UIColor clearColor];
    groupName.textColor=[UIColor blackColor];
    groupName.userInteractionEnabled=YES;
    [groupName setText:[NSString stringWithFormat: @"Group name: %@", appDelegate.currentGroupDictionary[@"name"]]];
    [self.view addSubview:groupName];
    
    //Group max number setting
    UILabel *maxNum = [[UILabel alloc] init];
    [maxNum setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/16 * 3,200,30)];
    maxNum.backgroundColor=[UIColor clearColor];
    maxNum.textColor=[UIColor blackColor];
    maxNum.userInteractionEnabled=YES;
    [maxNum setText:[NSString stringWithFormat: @"Max member: %@", appDelegate.currentGroupDictionary[@"maxnumber"]]];
    [self.view addSubview:maxNum];
    
    
    UILabel *label_info = [[UILabel alloc] init];
    [label_info setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/16 * 4,200,30)];
    label_info.backgroundColor=[UIColor clearColor];
    label_info.textColor=[UIColor blackColor];
    label_info.userInteractionEnabled=YES;
    [label_info setText:@"Group information: "];
    [self.view addSubview:label_info];
    
    
    UITextView *groupinfo = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/8 * 5 + 50, 200, 100)];
    [groupinfo setText:[NSString stringWithFormat: @"%@", appDelegate.currentGroupDictionary[@"groupinfo"]]];
    [self.view addSubview:groupinfo];
    
    if([appDelegate.firebase.authData.uid isEqualToString:@""]){
        QR_UID = @"ERROR";
    }
    else{
        QR_UID = [appDelegate.currentClassUid stringByAppendingString:@";"];
        QR_UID = [QR_UID stringByAppendingString:appDelegate.currentGroupUid];
    }
    CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.view.bounds.size.height * 0.5f - imageSize * 0.5f), imageSize, imageSize)];
    imageView.image = [UIImage mdQRCodeForString:QR_UID size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
    [self.view addSubview:imageView];
    
    CGRect group_frame = self.groupLabel.frame;
    group_frame.size.width = self.view.frame.size.width / 2;
    group_frame.origin.x = self.view.frame.size.width / 4;
    self.groupLabel.frame = group_frame;
    CGRect add_frame = self.add.frame;
    add_frame.origin.x = self.view.frame.size.width - add_frame.size.width - 10;
    self.add.frame = add_frame;
}


- (IBAction)addGroup:(id)sender {
    
//    NSLog(@"Button %ld %@", (long)button.tag, class_groups[class_groups_uid[button.tag]]);
//    appDelegate.currentGroupUid = class_groups_uid[button.tag];
//    appDelegate.currentGroupDictionary = class_groups[class_groups_uid[button.tag]];
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
        if(snapshot.childrenCount!=0)
            [groups addEntriesFromDictionary:snapshot.value];
        [groups setObject:appDelegate.currentClassUid forKey:appDelegate.currentGroupUid];
        [curr_user updateChildValues:groups];
    }];
    
    Firebase *curr_group = [appDelegate.firebase childByAppendingPath:@"classes"];
    curr_group = [curr_group childByAppendingPath:appDelegate.currentClassUid];
    curr_group = [curr_group childByAppendingPath:@"group"];
    curr_group = [curr_group childByAppendingPath:appDelegate.currentGroupUid];
    Firebase *teammember = [curr_group childByAppendingPath:@"teammember"];
    [teammember observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSMutableArray<NSString *> *member = snapshot.value;
//        NSNumber* index = [NSNumber numberWithInt:(int)members.count];
//        NSString* index_str = index.stringValue;
        if(![member containsObject:appDelegate.firebase.authData.uid]){
            [member insertObject:appDelegate.firebase.authData.uid atIndex:member.count];
        }
        NSDictionary *update_info = @{@"teammember" : member};
        [curr_group updateChildValues:update_info];
    }];
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"myGroupsViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

@end

