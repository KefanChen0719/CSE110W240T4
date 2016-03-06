//
//  UIViewController+AddGroupViewController.m
//  TeamUp
//
//  Created by Ryan Li on 3/3/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()

@end


@implementation AddGroupViewController
@synthesize appDelegate,viewcontroller;

NSString *group_uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    
    //Group name label setting
    UILabel *groupName = [[UILabel alloc] init];
    [groupName setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/8 * 3,200,30)];
    groupName.backgroundColor=[UIColor clearColor];
    groupName.textColor=[UIColor blackColor];
    groupName.userInteractionEnabled=YES;
    [groupName setText:[NSString stringWithFormat: @"Group name: %@", appDelegate.currentGroupDictionary[@"name"]]];
    [self.view addSubview:groupName];
    
    //Group max number setting
    UILabel *maxNum = [[UILabel alloc] init];
    [maxNum setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/8 * 4,200,30)];
    maxNum.backgroundColor=[UIColor clearColor];
    maxNum.textColor=[UIColor blackColor];
    maxNum.userInteractionEnabled=YES;
    [maxNum setText:[NSString stringWithFormat: @"Max member: %@", appDelegate.currentGroupDictionary[@"maxnumber"]]];
    [self.view addSubview:maxNum];
    
    
    UILabel *label_info = [[UILabel alloc] init];
    [label_info setFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/8 * 5,200,30)];
    label_info.backgroundColor=[UIColor clearColor];
    label_info.textColor=[UIColor blackColor];
    label_info.userInteractionEnabled=YES;
    [label_info setText:@"Group information: "];
    [self.view addSubview:label_info];
    
    
    UITextView *groupinfo = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/8 * 5 + 50, 200, 100)];
    [groupinfo setText:[NSString stringWithFormat: @"%@", appDelegate.currentGroupDictionary[@"groupinfo"]]];
    [self.view addSubview:groupinfo];
    
    
    
    
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

