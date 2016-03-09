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
@synthesize appDelegate,viewcontroller;

- (void)viewDidLoad {
    __block NSString* QR_UID = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect quit_frame = self.quitButton.frame;
    quit_frame.size.width = self.view.frame.size.width / 2;
    quit_frame.origin.x = self.view.frame.size.width / 4;
    quit_frame.origin.y = self.view.frame.size.height - quit_frame.size.height - 10;
    self.quitButton.frame = quit_frame;

    if(appDelegate.currentGroupUid && ![appDelegate.currentGroupUid isEqualToString:@""]){
        Firebase *curr_group = [appDelegate.firebase childByAppendingPath:@"classes"];
        curr_group = [curr_group childByAppendingPath:appDelegate.currentClassUid];
        curr_group = [curr_group childByAppendingPath:@"group"];
        curr_group = [curr_group childByAppendingPath:appDelegate.currentGroupUid];
        curr_group = [curr_group childByAppendingPath:@"teammember"];
        [curr_group observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSMutableArray<NSString *> *member = snapshot.value;
            //__block NSString* memberName = @"";
            if([appDelegate.firebase.authData.uid isEqualToString:@""]){
                QR_UID = @"ERROR";
            }
            else{
                QR_UID = [appDelegate.currentClassUid stringByAppendingString:@";"];
                QR_UID = [QR_UID stringByAppendingString:appDelegate.currentGroupUid];
            }
            CGFloat imageSize = ceilf(self.view.bounds.size.width * 0.6f);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.view.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(0), imageSize, imageSize)];
            imageView.image = [UIImage mdQRCodeForString:QR_UID size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
            UIScrollView *TeamMemberScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width, self.view.frame.size.height*0.8)];
            [TeamMemberScrollView setContentSize:CGSizeMake(TeamMemberScrollView.bounds.size.width,  member.count * self.view.frame.size.height*0.1 + imageSize + 200)];
            [TeamMemberScrollView addSubview:imageView];
            UITextView *groupinfo = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, imageSize, 200, 100)];
            [groupinfo setText:[NSString stringWithFormat: @"%@", appDelegate.currentGroupDictionary[@"groupinfo"]]];
            [TeamMemberScrollView addSubview:groupinfo];
//            for (NSInteger index = 0; index < member.count; index++)
//            {
//                __block UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                Firebase* curr_user_name = [appDelegate.firebase childByAppendingPath:@"users"];
//                curr_user_name = [curr_user_name childByAppendingPath: member[index]];
//                [curr_user_name observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//                    button.frame = CGRectMake(0, 100+imageSize + self.view.frame.size.height*0.1 * (CGFloat)index, self.view.frame.size.width,self.view.frame.size.height*0.1);
//                    [button setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1]];
//                    button.tag = index;
//                    [button setTitle:[NSString stringWithFormat:snapshot.value[@"name"], ((long)index + 1)] forState:UIControlStateNormal];
//                    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
//                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [[button layer] setBorderWidth:2.0f];
//                    button.layer.borderColor = [[UIColor colorWithRed:219.0/255.0 green:237.0/255.0 blue:238.0/255.0 alpha:1] CGColor];
//                }];
//                [TeamMemberScrollView addSubview:button];
//            }
            [self.view addSubview:TeamMemberScrollView];
        }];
        
    }
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
            //NSLog(@"NEW GROUP: %@", member);
            NSDictionary* update_group = @{@"teammember" : member};
            [[temp parent] updateChildValues:update_group];
        }
    }];
    
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"myGroupsViewController"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    
}


@end