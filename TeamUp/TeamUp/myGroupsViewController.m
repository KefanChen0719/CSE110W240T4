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
    
//    Firebase *temp = [[Firebase alloc] initWithUrl:@"https://resplendent-inferno-8485.firebaseio.com"];
//    temp = [temp childByAppendingPath:@"users"];
//    Firebase *curr_user = [temp childByAppendingPath:temp.authData.uid];
//    curr_user = [curr_user childByAppendingPath:@"groups"];
//    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        groups = snapshot.value;
//        groups_names = groups.allKeys;
//        NSUInteger group_num = groups_names.count;
//        NSLog(@"%lu: ", (unsigned long)group_num);
//    }];
//
    
    //Put number of groups here
    NSInteger numGroups = 5;

    [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*3)];
    
    
    for (NSInteger index = 0; index < numGroups; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //button.frame = CGRectMake((scrollView.frame.size.width / 2.0f) - 50.0f, 10.0f + (50.0f * (CGFloat)index), 100.0f, 30.0f);
        button.frame = CGRectMake(scrollView.frame.size.width * 0.1, 10.0f + (100.0f * (CGFloat)index), self.view.frame.size.width*0.8,self.view.frame.size.height*0.1);
        [button setBackgroundColor:[UIColor colorWithRed:163/255.0 green:205/255.0 blue:210/255.0 alpha:1.0]];
        button.tag = index;
        [button setTitle:[NSString stringWithFormat:@"Button %ld", ((long)index + 1)] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    
    
    [self.view addSubview:scrollView];
    
}

// Put the connection of each button here.
- (void)didTapButton:(UIButton *)button
{
    NSLog(@"Button %ld", (long)button.tag);
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}
@end
