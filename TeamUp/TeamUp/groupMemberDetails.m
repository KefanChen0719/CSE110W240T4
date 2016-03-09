//
//  groupMemberDetails.m
//  TeamUp
//
//  Created by Suli Huang on 3/8/16.
//  Copyright © 2016 CSE110W240T4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "groupMemberDetails.h"
@interface groupMemberDetails ()

@end

@implementation groupMemberDetails
@synthesize appDelegate,viewcontroller;

-(void)viewDidLoad{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Firebase *member= [appDelegate.firebase childByAppendingPath:@"users"];
    member =[member childByAppendingPath:appDelegate.member_uid];
    NSLog(@"%@", appDelegate.member_uid);
    [member observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"we are lookng: %@", snapshot.value[@"name"]);
        _nameLabel.text = snapshot.value[@"name"];
        _majorLabel.text = snapshot.value[@"major"];
        _yearLabel.text = snapshot.value[@"year"];
    }];
}

@end