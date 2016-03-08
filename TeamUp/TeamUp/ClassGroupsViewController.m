//
//  ClassGroupsViewController.m
//  TeamUp
//
//  Created by Jiasheng Zhu on 3/02/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "ClassGroupsViewController.h"
@interface ClassGroupsViewController ()

@end

@implementation ClassGroupsViewController
@synthesize appDelegate,viewcontroller;
NSDictionary *class_groups;
NSArray<NSString*> *class_groups_uid;



- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    CGRect name_frame = self.classNameLabel.frame;
    name_frame.size.width = self.view.frame.size.width / 2;
    name_frame.origin.x = self.view.frame.size.width / 4;
    self.classNameLabel.frame = name_frame;
    CGRect button_frame = self.addButton.frame;
    button_frame.origin.x = self.view.frame.size.width - button_frame.size.width - 10;
    self.addButton.frame = button_frame;
    NSLog(@"ClassGroupsViewController: %@ ", appDelegate.currentClassUid);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width, self.view.frame.size.height*0.8)];
    Firebase *curr_class = [appDelegate.firebase childByAppendingPath:@"classes"];
    curr_class = [curr_class childByAppendingPath:appDelegate.currentClassUid];
        [curr_class observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSString* class_name = [snapshot.value valueForKey:@"name"];
            self.classNameLabel.text = [class_name uppercaseString];
        }];
    curr_class = [curr_class childByAppendingPath:@"group"];
    [curr_class observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        class_groups = snapshot.value;
        NSUInteger numGroups = 0;
        if(snapshot.childrenCount != 0){
            class_groups_uid = class_groups.allKeys;
            NSUInteger group_num = class_groups_uid.count;
            NSLog(@"%lu: ", (unsigned long)group_num);
            numGroups = class_groups_uid.count;
        }
        else{
            numGroups = 0;
        }
        
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*3)];
        CGRect contentRect = CGRectZero;
        
        for (NSInteger index = 0; index < numGroups; index++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //button.frame = CGRectMake((scrollView.frame.size.width / 2.0f) - 50.0f, 10.0f + (50.0f * (CGFloat)index), 100.0f, 30.0f);
            //button.frame = CGRectMake(scrollView.frame.size.width * 0.1, 10.0f + (100.0f * (CGFloat)index), self.view.frame.size.width*0.8,self.view.frame.size.height*0.1);
            button.frame = CGRectMake(0, self.view.frame.size.height*0.1 * (CGFloat)index, self.view.frame.size.width,self.view.frame.size.height*0.1);
            //[button setBackgroundColor:[UIColor colorWithRed:163/255.0 green:205/255.0 blue:210/255.0 alpha:1.0]];
            [button setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1]];
            button.tag = index;
            [button setTitle:[NSString stringWithFormat:[self getNameFromGroupUid: class_groups_uid[index]], ((long)index + 1)] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[button layer] setBorderWidth:2.0f];
            button.layer.borderColor = [[UIColor colorWithRed:219.0/255.0 green:237.0/255.0 blue:238.0/255.0 alpha:1] CGColor];
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
            contentRect = CGRectUnion(contentRect, button.frame);
        }
        scrollView.contentSize = contentRect.size;
        
        [self.view addSubview:scrollView];
    }];

}

// Put the connection of each button here.
- (void)didTapButton:(UIButton *)button
{
    NSLog(@"Button %ld %@", (long)button.tag, class_groups[class_groups_uid[button.tag]]);
    appDelegate.currentGroupUid = class_groups_uid[button.tag];
    appDelegate.currentGroupDictionary = class_groups[class_groups_uid[button.tag]];
//    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
//    curr_user = [curr_user childByAppendingPath:@"groups"];
//    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSMutableDictionary *groups = [[NSMutableDictionary alloc] init];
//        if(snapshot.childrenCount!=0)
//        [groups addEntriesFromDictionary:snapshot.value];
//        [groups setObject:appDelegate.currentClassUid forKey:class_groups_uid[button.tag]];
//        [curr_user updateChildValues:groups];
//          viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddGroup"];
//        [self presentViewController:viewcontroller animated:YES completion:nil];
//    }];
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddGroup"];
    [self presentViewController:viewcontroller animated:YES completion:nil];

}




- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

- (NSString *) getNameFromGroupUid:(NSString*) group_uid{
    NSString* group_name = @"";
    group_name = [group_uid substringFromIndex:36];
    return group_name;
}
@end