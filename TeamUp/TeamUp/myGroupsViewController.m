//
//  UIViewController+myGroupsViewController.m
//  TeamUp
//
//  Created by Ryan Li on 2/24/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import "myGroupsViewController.h"
@interface myGroupsViewController ()

@end

@implementation myGroupsViewController
@synthesize appDelegate;
NSDictionary *groups;
NSArray<NSString*> *groups_names;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width, self.view.frame.size.height*0.8)];
    Firebase *temp = [[Firebase alloc] initWithUrl:@"https://resplendent-inferno-8485.firebaseio.com"];
    temp = [temp childByAppendingPath:@"users"];
    Firebase *curr_user = [temp childByAppendingPath:temp.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        groups = snapshot.value;
        groups_names = groups.allKeys;
        NSUInteger group_num = groups_names.count;
        NSLog(@"%lu: ", (unsigned long)group_num);
    }];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*3)];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05,self.view.frame.size.height*0.01,self.view.frame.size.width*0.9,self.view.frame.size.height*0.1)];
    [playButton setTitle:@"HIT ME" forState:UIControlStateNormal];
    [playButton setBackgroundColor:[UIColor colorWithRed:163/255.0 green:205/255.0 blue:210/255.0 alpha:1.0]];
    [scrollView addSubview:playButton];
    
//    UIButton *playButton2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05,self.view.frame.size.height*0.12,self.view.frame.size.width*0.9,self.view.frame.size.height*0.1)];
//    [playButton2 setTitle:@"HIT ME" forState:UIControlStateNormal];
//    [playButton2 setBackgroundColor:[UIColor colorWithRed:163/255.0 green:205/255.0 blue:210/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}
@end
