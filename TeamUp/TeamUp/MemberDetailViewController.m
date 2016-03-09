//
//  MemberDetailViewController.m
//  TeamUp
//
//  Created by Jiasheng Zhu on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberDetailViewController.h"
@interface MemberDetailViewController ()

@end

@implementation MemberDetailViewController
@synthesize appDelegate,viewcontroller, GroupNameLabel;
UITextView *groupinfo;
UITextField *maxNumer;
- (void)viewDidLoad {
    __block NSString* QR_UID = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect quit_frame = self.quitButton.frame;
    quit_frame.size.width = self.view.frame.size.width / 2;
    quit_frame.origin.x = self.view.frame.size.width / 4;
    quit_frame.origin.y = self.view.frame.size.height - quit_frame.size.height - 10;
    self.quitButton.frame = quit_frame;
    CGRect update_frame = self.updateButton.frame;
    update_frame.origin.x = self.view.frame.size.width - update_frame.size.width - 10;
    self.updateButton.frame = update_frame;
    CGRect detail_frame = self.memberDetailButton.frame;
    detail_frame.size.width = self.view.frame.size.width / 2;
    detail_frame.origin.x = self.view.frame.size.width / 4;
    detail_frame.origin.y = quit_frame.origin.y - detail_frame.size.height - 5;
    self.memberDetailButton.frame = detail_frame;

    if(appDelegate.currentGroupUid && ![appDelegate.currentGroupUid isEqualToString:@""]){
        Firebase *curr_group = [appDelegate.firebase childByAppendingPath:@"classes"];
        curr_group = [curr_group childByAppendingPath:appDelegate.currentClassUid];
        curr_group = [curr_group childByAppendingPath:@"group"];
        curr_group = [curr_group childByAppendingPath:appDelegate.currentGroupUid];
        [curr_group observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *member = snapshot.value;
            if([appDelegate.firebase.authData.uid isEqualToString:@""]){
                QR_UID = @"ERROR";
            }
            else{
                QR_UID = [appDelegate.currentClassUid stringByAppendingString:@";"];
                QR_UID = [QR_UID stringByAppendingString:appDelegate.currentGroupUid];
            }
            CGFloat infoSize = ceilf(self.view.bounds.size.width * 0.8f);
            groupinfo = [[UITextView alloc]initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.1f), floorf(self.view.frame.size.height*0.15), infoSize, infoSize/3.5)];
            maxNumer = [[UITextField alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.1f), floorf(self.view.frame.size.height*0.15 + infoSize/3.1), infoSize, infoSize/9)];
            [maxNumer setBorderStyle:UITextBorderStyleRoundedRect];
            NSString* maxNumPlaceHolder = @"Max Number Is: ";
            NSString* max_num = member[@"maxnumber"];
            maxNumPlaceHolder = [maxNumPlaceHolder stringByAppendingString:max_num];
            [maxNumer setPlaceholder:maxNumPlaceHolder];
            [groupinfo setText:[NSString stringWithFormat: @"%@", member[@"groupinfo"]]];
            GroupNameLabel.text = member[@"name"];
            CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.8f);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.1f), floorf(self.view.frame.size.height*0.15) + infoSize/2, imageSize, imageSize)];
            imageView.image = [UIImage mdQRCodeForString:QR_UID size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
            [self.view addSubview:maxNumer];
            [self.view addSubview:imageView];
            [self.view addSubview:groupinfo];
        }];
        
    }
}

- (IBAction)UpdateGroupInfo:(id)sender{
    Firebase* temp = [appDelegate.firebase childByAppendingPath:@"classes"];
    temp = [temp childByAppendingPath:appDelegate.Quit_ClassUid];
    temp = [temp childByAppendingPath:@"group"];
    temp = [temp childByAppendingPath:appDelegate.currentGroupUid];
    [temp observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.childrenCount!=0) {
            NSMutableDictionary *group_info = snapshot.value;
            NSString *new_group_info = groupinfo.text;
            NSString *new_max_number = maxNumer.text;
            NSUInteger max_number = [new_max_number integerValue];
            if(max_number){
                [group_info setValue:[NSString stringWithFormat:@"%lu",max_number] forKey:@"maxnumber"];
            }
            [group_info setValue:new_group_info forKey:@"groupinfo"];
            [temp updateChildValues:group_info];
        }
    }];

}

- (IBAction)quitGroup:(id)sender {
    
    
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    
    Firebase *group_dict = [curr_user childByAppendingPath:@"groups"];
    
    
    
    [group_dict observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSMutableDictionary *groups = snapshot.value;
        NSString *group_uid = appDelegate.currentGroupUid;
        [groups removeObjectForKey:group_uid];
        NSDictionary* update_group = @{@"groups" : groups};
        [[group_dict parent] updateChildValues:update_group];
    }];
    
    Firebase *class = [appDelegate.firebase childByAppendingPath:@"classes"];
    class = [class childByAppendingPath:appDelegate.Quit_ClassUid];
    class = [class childByAppendingPath:@"group"];
    
    Firebase* temp = [appDelegate.firebase childByAppendingPath:@"classes"];
    temp = [temp childByAppendingPath:appDelegate.Quit_ClassUid];
    temp = [temp childByAppendingPath:@"group"];
    temp = [temp childByAppendingPath:appDelegate.currentGroupUid];
    temp = [temp childByAppendingPath:@"teammember"];
    [temp observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.childrenCount!=0) {
            NSMutableArray *member = snapshot.value;
            NSString *user_uid = appDelegate.uid;
            [member removeObject:user_uid];
            NSDictionary* update_group = @{@"teammember" : member};
            [[temp parent] updateChildValues:update_group];
        }
    }];
    
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"myGroupsViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    
}


@end