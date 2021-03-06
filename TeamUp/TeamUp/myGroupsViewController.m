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

NSString *email4;
NSString *year4;
NSString *major4;

@implementation myGroupsViewController
@synthesize appDelegate,viewcontroller,spinner;
NSDictionary *groups;
NSArray<NSString*> *groups_uid;



- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *view = self.topView.superview;
    CGRect view_frame = view.frame;
    CGRect topView_frame = self.topView.frame;
    topView_frame.size.width = view_frame.size.width;
    self.topView.frame = topView_frame;
    CGRect signOut_frame = self.signOut.frame;
    signOut_frame.origin.x = 5;
    self.signOut.frame = signOut_frame;
    CGRect topLabel_frame = self.topLabel.frame;
    topLabel_frame.origin.x = view_frame.size.width / 5;
    topLabel_frame.size.width = view_frame.size.width / 5 * 3;
    self.topLabel.frame = topLabel_frame;
    CGRect add_frame = self.add.frame;
    add_frame.origin.x = view_frame.size.width - add_frame.size.width - 5;
    self.add.frame = add_frame;
    CGRect accountButton_frame = self.accountButton.frame;
    accountButton_frame.origin.x = view_frame.size.width - accountButton_frame.size.width - 5;
    accountButton_frame.origin.y = view_frame.size.height - accountButton_frame.size.height - 5;
    self.accountButton.frame = accountButton_frame;
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(view.frame.size.width/2,  view.frame.size.height/2)]; // I do this because I'm in landscape mode
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
}


- (void) viewDidAppear:(BOOL)animated {
    
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.8)];
    //UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, 100)];
    Firebase *curr_user = [appDelegate.users_ref childByAppendingPath:appDelegate.firebase.authData.uid];
    curr_user = [curr_user childByAppendingPath:@"groups"];
    [curr_user observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        groups = snapshot.value;
        NSUInteger numGroups = 0;
        if(snapshot.childrenCount != 0){
            groups_uid = groups.allKeys;
            NSUInteger group_num = groups_uid.count;
            NSLog(@"%lu: ", (unsigned long)group_num);
            numGroups = groups_uid.count;
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
            //button.frame = CGRectMake(scrollView.frame.size.width * 0.1, 10.0f + (100.0f * (CGFloat)index), self.view.frame.size.width*0.8,self.view.frame.size.height*0.1 / 9 * 7);
            button.frame = CGRectMake(0, self.view.frame.size.height*0.1 * (CGFloat)index, self.view.frame.size.width,self.view.frame.size.height*0.1);
            [button setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1]];
            button.tag = index;
            appDelegate.Quit_ClassUid = groups[groups_uid[index]];
            NSString *string = [NSString stringWithFormat:@"%@%@%@", [groups[groups_uid[index]] uppercaseString], @"  ", [self getNameFromGroupUid: groups_uid[index]]];
            [button setTitle:[NSString stringWithFormat:string, ((long)index + 1)] forState:UIControlStateNormal];
            //button.layer.cornerRadius = 9;
            [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[button layer] setBorderWidth:2.0f];
            //UIColor *c = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            //button.layer.borderColor = [c CGColor];
            //button.layer.borderColor=[[UIColor blackColor]CGColor];
            button.layer.borderColor = [[UIColor colorWithRed:219.0/255.0 green:237.0/255.0 blue:238.0/255.0 alpha:1] CGColor];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
            contentRect = CGRectUnion(contentRect, button.frame);
        }
        
        
        scrollView.contentSize = contentRect.size;
        
        
        [self.view addSubview:scrollView];
         [spinner stopAnimating];
    }];
   
}



// Put the connection of each button here.
- (void)didTapButton:(UIButton *)button
{
    NSLog(@"Button %ld %@", (long)button.tag, groups[groups_uid[button.tag]]);
    NSString * currentGroupUid = groups_uid[button.tag];
    appDelegate.currentGroupUid = currentGroupUid;
    appDelegate.currentClassUid = groups[groups_uid[button.tag]];
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewContr"];
  
    MessagesViewController* vc = (MessagesViewController *) viewcontroller;
    vc.groupID = currentGroupUid;
    vc.viewWidth = [NSString stringWithFormat: @"%.2f", self.view.frame.size.width];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (IBAction)signOut:(id)sender{
    [appDelegate.firebase unauth];
    
    NSString *signOut  = @"True";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:signOut forKey:@"signOut"];
    
    [defaults synchronize];
    
    NSLog(@"user should be signed out");
    email4 = @"";
    appDelegate.uid = @"";
    appDelegate.name = @"";
    year4 = @"";
    major4 = @"";
    
    viewcontroller = [appDelegate.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//  
//}

@end
